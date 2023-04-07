local Png = {}
Png.__index = Png

local png_ihdr_t = ffi.typeof([[
struct {
	char type[4];
	uint32_t width;
	uint32_t height;
	char bitDepth;
	char colorType;
	char compression;
	char filter;
	char interlace;
} *
]])

local jpg_segment_t = ffi.typeof([[
struct {
	char type[2];
	uint16_t size;
} *
]])

local jpg_segment_sof0_t = ffi.typeof([[
struct {
	uint16_t size;
	char precision;
	uint16_t height;
	uint16_t width;
} __attribute__((packed)) *
]])

local uint16_t_ptr = ffi.typeof("uint16_t*")
local charbuffer = ffi.typeof("unsigned char[?]")
local uintbuffer = ffi.typeof("unsigned int[?]")

local INVALID_TEXTURE = -1
local PNG_MAGIC = "\x89\x50\x4E\x47\x0D\x0A\x1A\x0A"

local JPG_MAGIC_1 = "\xFF\xD8\xFF\xDB"
local JPG_MAGIC_2 = "\xFF\xD8\xFF\xE0\x00\x10\x4A\x46\x49\x46\x00\x01"

local JPG_SEGMENT_SOI = "\xFF\xD8"
local JPG_SEGMENT_SOF0 = "\xFF\xC0"
local JPG_SEGMENT_SOS = "\xFF\xDA"
local JPG_SEGMENT_EOI = "\xFF\xD9"

local DEFAULT_AVATAR
local DEFLATE_MAX_BLOCK_SIZE = 65535

local function putBigUint32(val, tbl, index)
    for i=0,3 do
        tbl[index + i] = bit.band(bit.rshift(val, (3 - i) * 8), 0xFF)
    end
end

function Png:writeBytes(data, index, len)
    index = index or 1
    len = len or #data
    for i=index,index+len-1 do
        table.insert(self.output, string.char(data[i]))
    end
end

function Png:write(pixels)
    local count = #pixels  -- Byte count
    local pixelPointer = 1
    while count > 0 do
        if self.positionY >= self.height then
            error("All image pixels already written")
        end

        if self.deflateFilled == 0 then -- Start DEFLATE block
            local size = DEFLATE_MAX_BLOCK_SIZE;
            if (self.uncompRemain < size) then
                size = self.uncompRemain
            end
            local header = {  -- 5 bytes long
                bit.band((self.uncompRemain <= DEFLATE_MAX_BLOCK_SIZE and 1 or 0), 0xFF),
                bit.band(bit.rshift(size, 0), 0xFF),
                bit.band(bit.rshift(size, 8), 0xFF),
                bit.band(bit.bxor(bit.rshift(size, 0), 0xFF), 0xFF),
                bit.band(bit.bxor(bit.rshift(size, 8), 0xFF), 0xFF),
            }
            self:writeBytes(header)
            self:crc32(header, 1, #header)
        end
        assert(self.positionX < self.lineSize and self.deflateFilled < DEFLATE_MAX_BLOCK_SIZE);

        if (self.positionX == 0) then  -- Beginning of line - write filter method byte
            local b = {0}
            self:writeBytes(b)
            self:crc32(b, 1, 1)
            self:adler32(b, 1, 1)
            self.positionX = self.positionX + 1
            self.uncompRemain = self.uncompRemain - 1
            self.deflateFilled = self.deflateFilled + 1
        else -- Write some pixel bytes for current line
            local n = DEFLATE_MAX_BLOCK_SIZE - self.deflateFilled;
            if (self.lineSize - self.positionX < n) then
                n = self.lineSize - self.positionX
            end
            if (count < n) then
                n = count;
            end
            assert(n > 0);

            self:writeBytes(pixels, pixelPointer, n)

            -- Update checksums
            self:crc32(pixels, pixelPointer, n);
            self:adler32(pixels, pixelPointer, n);

            -- Increment positions
            count = count - n;
            pixelPointer = pixelPointer + n;
            self.positionX = self.positionX + n;
            self.uncompRemain = self.uncompRemain - n;
            self.deflateFilled = self.deflateFilled + n;
        end

        if (self.deflateFilled >= DEFLATE_MAX_BLOCK_SIZE) then
            self.deflateFilled = 0; -- End current block
        end

        if (self.positionX == self.lineSize) then  -- Increment line
            self.positionX = 0;
            self.positionY = self.positionY + 1;
            if (self.positionY == self.height) then -- Reached end of pixels
                local footer = {  -- 20 bytes long
                    0, 0, 0, 0,  -- DEFLATE Adler-32 placeholder
                    0, 0, 0, 0,  -- IDAT CRC-32 placeholder
                    -- IEND chunk
                    0x00, 0x00, 0x00, 0x00,
                    0x49, 0x45, 0x4E, 0x44,
                    0xAE, 0x42, 0x60, 0x82,
                }
                putBigUint32(self.adler, footer, 1)
                self:crc32(footer, 1, 4)
                putBigUint32(self.crc, footer, 5)
                self:writeBytes(footer)
                self.done = true
            end
        end
    end
end

function Png:crc32(data, index, len)
    self.crc = bit.bnot(self.crc)
    for i=index,index+len-1 do
        local byte = data[i]
        for j=0,7 do  -- Inefficient bitwise implementation, instead of table-based
            local nbit = bit.band(bit.bxor(self.crc, bit.rshift(byte, j)), 1);
            self.crc = bit.bxor(bit.rshift(self.crc, 1), bit.band((-nbit), 0xEDB88320));
        end
    end
    self.crc = bit.bnot(self.crc)
end

function Png:adler32(data, index, len)
    local s1 = bit.band(self.adler, 0xFFFF)
    local s2 = bit.rshift(self.adler, 16)
    for i=index,index+len-1 do
        s1 = (s1 + data[i]) % 65521
        s2 = (s2 + s1) % 65521
    end
    self.adler = bit.bor(bit.lshift(s2, 16), s1)
end

local function transform(input)
    local output = string.format("%x", input) -- "7F"
    return ("\\x" .. string.upper(output))
end

local function begin(width, height, colorMode)
    -- Default to rgb
    colorMode = colorMode or "rgb"

    -- Determine bytes per pixel and the PNG internal color type
    local bytesPerPixel, colorType
    if colorMode == "rgb" then
        bytesPerPixel, colorType = 3, 2
    elseif colorMode == "rgba" then
        bytesPerPixel, colorType = 4, 6
    else
        error("Invalid colorMode")
    end

    local state = setmetatable({ width = width, height = height, done = false, output = {} }, Png)

    -- Compute and check data siezs
    state.lineSize = width * bytesPerPixel + 1
    -- TODO: check if lineSize too big

    state.uncompRemain = state.lineSize * height

    local numBlocks = math.ceil(state.uncompRemain / DEFLATE_MAX_BLOCK_SIZE)

    -- 5 bytes per DEFLATE uncompressed block header, 2 bytes for zlib header, 4 bytes for zlib Adler-32 footer
    local idatSize = numBlocks * 5 + 6
    idatSize = idatSize + state.uncompRemain;

    -- TODO check if idatSize too big

    local header = {  -- 43 bytes long
        -- PNG header
        0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
        -- IHDR chunk
        0x00, 0x00, 0x00, 0x0D,
        0x49, 0x48, 0x44, 0x52,
        0, 0, 0, 0,  -- 'width' placeholder
        0, 0, 0, 0,  -- 'height' placeholder
        0x08, colorType, 0x00, 0x00, 0x00,
        0, 0, 0, 0,  -- IHDR CRC-32 placeholder
        -- IDAT chunk
        0, 0, 0, 0,  -- 'idatSize' placeholder
        0x49, 0x44, 0x41, 0x54,
        -- DEFLATE data
        0x08, 0x1D,
    }
    putBigUint32(width, header, 17)
    putBigUint32(height, header, 21)
    putBigUint32(idatSize, header, 34)

    state.crc = 0
    state:crc32(header, 13, 17)
    putBigUint32(state.crc, header, 30)
    state:writeBytes(header)

    state.crc = 0
    state:crc32(header, 38, 6);  -- 0xD7245B6B
    state.adler = 1

    state.positionX = 0
    state.positionY = 0
    state.deflateFilled = 0

    return state
end

ffi.cdef([[
	typedef struct
	{
		void* steam_client;
		void* steam_user;
		void* steam_friends;
		void* steam_utils;
		void* steam_matchmaking;
		void* steam_user_stats;
		void* steam_apps;
		void* steam_matchmakingservers;
		void* steam_networking;
		void* steam_remotestorage;
		void* steam_screenshots;
		void* steam_http;
		void* steam_unidentifiedmessages;
		void* steam_controller;
		void* steam_ugc;
		void* steam_applist;
		void* steam_music;
		void* steam_musicremote;
		void* steam_htmlsurface;
		void* steam_inventory;
		void* steam_video;
	} S_steamApiCtx_t;
]])

local pS_SteamApiCtx = ffi.cast(
	"S_steamApiCtx_t**", ffi.cast(
		"char*",
		memory.find_pattern(
			"client.dll",
			"FF 15 ?? ?? ?? ?? B9 ?? ?? ?? ?? E8 ?? ?? ?? ?? 6A"
		)
	) + 7
)[0] or error("invalid interface", 2)

local native_ISteamFriends = ffi.cast("void***", pS_SteamApiCtx.steam_friends)
local native_ISteamUtils = ffi.cast("void***", pS_SteamApiCtx.steam_utils)

local native_ISteamFriends_GetSmallFriendAvatar = ffi.cast("int(__thiscall*)(void*, uint64_t)", native_ISteamFriends[0][34])
local native_ISteamFriends_GetMediumFriendAvatar = ffi.cast("int(__thiscall*)(void*, uint64_t)", native_ISteamFriends[0][35])
local native_ISteamFriends_GetLargeFriendAvatar = ffi.cast("int(__thiscall*)(void*, uint64_t)", native_ISteamFriends[0][36])

local native_ISteamUtils_GetImageSize = ffi.cast("bool(__thiscall*)(void*, int, uint32_t*, uint32_t*)", native_ISteamUtils[0][5])
local native_ISteamUtils_GetImageRGBA =  ffi.cast("bool(__thiscall*)(void*, int, unsigned char*, int)", native_ISteamUtils[0][6])

local steam_avatars = {}
local function get_avatart(steamid, size)
    if steamid == nil then
        return
    end
    
    local cache_key = string.format("%s_%s", steamid, size)
    local huy
    local image_bytes = ""

    if steam_avatars[cache_key] == nil then
        local counter = 4
        local rgba_image = {}

        local func
        if size == nil then
            func = native_ISteamFriends_GetSmallFriendAvatar
        elseif size > 64 then
            func = native_ISteamFriends_GetLargeFriendAvatar
        elseif size > 32 then
            func = native_ISteamFriends_GetMediumFriendAvatar
        else
            func = native_ISteamFriends_GetSmallFriendAvatar
        end

        local handle = func(native_ISteamFriends, tonumber(steamid:sub(4, -1)) + 76500000000000000ULL)
        
        if handle > 0 then
            local width = uintbuffer(1)
            local height = uintbuffer(1)

            if native_ISteamUtils_GetImageSize(native_ISteamUtils, handle, width, height) then
                if width[0] > 0 and height[0] > 0 then
                    local rgba_buffer_size = width[0]*height[0]*4
                    local rgba_buffer = charbuffer(rgba_buffer_size)

                    if native_ISteamUtils_GetImageRGBA(native_ISteamUtils, handle, rgba_buffer, rgba_buffer_size) then
                        local png = begin(width[0] , height[0] , "rgba")

                        for x =0 , width[0]-1 do
                            for y =0, height[0]-1 do
                                local pizda = x*(height[0]*4) + y*4

                                png:write {rgba_buffer[pizda] , rgba_buffer[pizda+1] ,  rgba_buffer[pizda+2] ,  rgba_buffer[pizda+3]}
                            end
                        end

                        for i = 1, #png.output do  
                            image_bytes = image_bytes .. png.output[i]
                        end

                        steam_avatars[cache_key] = render.load_image_buffer(image_bytes)
                    end
                end
            end
        elseif handle ~= -1 then
            steam_avatars[cache_key] = nil
        end
    end

    if steam_avatars[cache_key] then
        return steam_avatars[cache_key]
    end
end

return {
    get = get_avatart}