const sfo = @import("../sfo.zig");

pub const KvDescriptor = struct {
    name: []const u8,
    description: []const u8,
    attributes: union(sfo.FmtType) {
        rsv4: struct {
            max_len: u16,
        },
        utf8: struct {
            max_len: u16,
        },
        int32: void,
    },
    flags: packed struct {
        is_legacy: bool = false,
    } = .{},
};
pub const DESCRIPTORS = [_]KvDescriptor{ .{
    .name = "FORMAT",
    .description = "Format",
    .attributes = .{ .utf8 = .{ .max_len = 4 } },
}, .{
    .name = "CATEGORY",
    .description = "Category",
    .attributes = .{ .utf8 = .{ .max_len = 4 } },
}, .{
    .name = "TITLE_ID",
    .description = "Title ID",
    .attributes = .{ .utf8 = .{ .max_len = 12 } },
}, .{
    .name = "PARENTAL_LEVEL",
    .description = "Parental Lock Level",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "ATTRIBUTE",
    .description = "Various parameter",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "ATTRIBUTE2",
    .description = "Various parameter",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "PS3_SYSTEM_VER",
    .description = "System's required version (PS3)",
    .attributes = .{ .utf8 = .{ .max_len = 8 } },
}, .{
    .name = "PSP2_SYSTEM_VER",
    .description = "System's required version (PSP2)",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "PSP2_DISP_VER",
    .description = "System's required version (PSP2) for display",
    .attributes = .{ .utf8 = .{ .max_len = 8 } },
}, .{
    .name = "SYSTEM_VER",
    .description = "System's required version",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "VERSION",
    .description = "Master's version",
    .attributes = .{ .utf8 = .{ .max_len = 8 } },
}, .{
    .name = "APP_VER",
    .description = "Application Version",
    .attributes = .{ .utf8 = .{ .max_len = 8 } },
}, .{
    .name = "TARGET_APP_VER",
    .description = "Target Application Version",
    .attributes = .{ .utf8 = .{ .max_len = 8 } },
}, .{
    .name = "BOOTABLE",
    .description = "Is bootable or not",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "LICENSE",
    .description = "License information",
    .attributes = .{ .utf8 = .{ .max_len = 512 } },
}, .{
    .name = "RESOLUTION",
    .description = "Supported resolution",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "SOUND_FORMAT",
    .description = "Sound Format",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "APP_TYPE",
    .description = "Application Type",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "DOWNLOAD_DATA_SIZE",
    .description = "Download Data Size (/download0)",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "DOWNLOAD_DATA_SIZE_1",
    .description = "Download Data Size (/download1)",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "SERVICE_ID_ADDCONT_ADD_1",
    .description = "Placeholder by system",
    .attributes = .{ .utf8 = .{ .max_len = 20 } },
}, .{
    .name = "SERVICE_ID_ADDCONT_ADD_2",
    .description = "Placeholder by system",
    .attributes = .{ .utf8 = .{ .max_len = 20 } },
}, .{
    .name = "SERVICE_ID_ADDCONT_ADD_3",
    .description = "Placeholder by system",
    .attributes = .{ .utf8 = .{ .max_len = 20 } },
}, .{
    .name = "SERVICE_ID_ADDCONT_ADD_4",
    .description = "Placeholder by system",
    .attributes = .{ .utf8 = .{ .max_len = 20 } },
}, .{
    .name = "SERVICE_ID_ADDCONT_ADD_5",
    .description = "Placeholder by system",
    .attributes = .{ .utf8 = .{ .max_len = 20 } },
}, .{
    .name = "SERVICE_ID_ADDCONT_ADD_6",
    .description = "Placeholder by system",
    .attributes = .{ .utf8 = .{ .max_len = 20 } },
}, .{
    .name = "SERVICE_ID_ADDCONT_ADD_7",
    .description = "Placeholder by system",
    .attributes = .{ .utf8 = .{ .max_len = 20 } },
}, .{
    .name = "DISP_LOCATION_1",
    .description = "Display Location (Initial)",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "DISP_LOCATION_2",
    .description = "Display Location (Triggered)",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "PS3_TITLE_ID_LIST_FOR_BOOT",
    .description = "Title IDs of the PS3 Key Disc",
    .attributes = .{ .utf8 = .{ .max_len = 512 } },
}, .{
    .name = "REMOTE_PLAY_KEY_ASSIGN",
    .description = "Key assignment pattern for the Remote Play",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "USER_DEFINED_PARAM_1",
    .description = "User-defined parameter 1",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "USER_DEFINED_PARAM_2",
    .description = "User-defined parameter 2",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "USER_DEFINED_PARAM_3",
    .description = "User-defined parameter 3",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "USER_DEFINED_PARAM_4",
    .description = "User-defined parameter 4",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "WEBLINK_URI",
    .description = "Weblink URI",
    .attributes = .{ .utf8 = .{ .max_len = 2048 } },
}, .{
    .name = "SMALL_SHARED_DATA_ID",
    .description = "Small Shared Data ID",
    .attributes = .{ .utf8 = .{ .max_len = 12 } },
}, .{
    .name = "REMASTER_TYPE",
    .description = "Remaster Type",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "PT_PARAM",
    .description = "Play Together parameter",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "DMEM_FLAG",
    .description = "Direct Memory Flag",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "IRO_TAG_BMP_0",
    .description = "IRO Tag Bitmap",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "IRO_TAG_BMP_1",
    .description = "IRO Tag Bitmap",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "IRO_TAG_BMP_2",
    .description = "IRO Tag Bitmap",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "IRO_TAG_BMP_3",
    .description = "IRO Tag Bitmap",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "IRO_TAG_BMP_4",
    .description = "IRO Tag Bitmap",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "IRO_TAG_BMP_5",
    .description = "IRO Tag Bitmap",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "IRO_TAG_BMP_6",
    .description = "IRO Tag Bitmap",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "IRO_TAG_BMP_7",
    .description = "IRO Tag Bitmap",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "IRO_TAG",
    .description = "IRO Tag",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "CONTENT_VER",
    .description = "Version information of the content",
    .attributes = .{ .utf8 = .{ .max_len = 8 } },
}, .{
    .name = "ATTRIBUTE_EXE",
    .description = "Various parameter",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "USB_DIR_LIST",
    .description = "USB mass storage directory names",
    .attributes = .{ .utf8 = .{ .max_len = 256 } },
}, .{
    .name = "PUBTOOLINFO",
    .description = "Application-specific parameters",
    .attributes = .{ .utf8 = .{ .max_len = 512 } },
}, .{
    .name = "BUILD_INFO",
    .description = "Build Information",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "EMU_VER",
    .description = "Emulator Version",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "PSMKIT_VER",
    .description = "PSM-Kit Version",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "SELF_2MIB_PAGE_AMOUNT",
    .description = "Reserved 2-Mbyte Page Amount (in bytes)",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "DISC_NUMBER",
    .description = "Disc Number",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "DISC_TOTAL",
    .description = "Total Number of Discs",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "PARENTAL_LEVEL_J",
    .description = "Parental Lock Level (SCEJ)",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "PARENTAL_LEVEL_A",
    .description = "Parental Lock Level (SCEA)",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "PARENTAL_LEVEL_E",
    .description = "Parental Lock Level (SCEE)",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "PARENTAL_LEVEL_H",
    .description = "Parental Lock Level (SCEH)",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "PARENTAL_LEVEL_K",
    .description = "Parental Lock Level (SCEK)",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "PARENTAL_LEVEL_C",
    .description = "Parental Lock Level (SCH)",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "CONTENT_ID",
    .description = "Content ID",
    .attributes = .{ .utf8 = .{ .max_len = 48 } },
}, .{
    .name = "GAMEDATA_ID",
    .description = "",
    .attributes = .{ .utf8 = .{ .max_len = 32 } },
}, .{
    .name = "NP_COMMUNICATION_ID",
    .description = "NP Communication ID",
    .attributes = .{ .utf8 = .{ .max_len = 16 } },
}, .{
    .name = "REGION_DENY",
    .description = "Region Restriction Information",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "SAVEDATA_MAX_SIZE",
    .description = "Save Data Quota",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "SAFEMEMORY_MODE",
    .description = "SafeMemory Mode",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "GC_RO_SIZE",
    .description = "PS Vita card R/O size",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "GC_RW_SIZE",
    .description = "PS Vita card R/W size",
    .attributes = .{ .int32 = {} },
}, .{
    .name = "INSTALL_DIR_SAVEDATA",
    .description = "Title ID used by Shared Save Data",
    .attributes = .{ .utf8 = .{ .max_len = 12 } },
}, .{
    .name = "INSTALL_DIR_ADDCONT",
    .description = "Title ID used by Shared Additional Content",
    .attributes = .{ .utf8 = .{ .max_len = 12 } },
}, .{
    .name = "SUPPORT_URI",
    .description = "Supported Scheme/URI by application",
    .attributes = .{ .utf8 = .{ .max_len = 512 } },
    .flags = .{ .is_legacy = true },
}, .{
    .name = "INSTALL_DIR_SAVEDATA_ADD_1",
    .description = "Title ID of the importable app by Save Data Transfer",
    .attributes = .{ .utf8 = .{ .max_len = 12 } },
}, .{
    .name = "INSTALL_DIR_SAVEDATA_ADD_2",
    .description = "Title ID of the importable app by Save Data Transfer",
    .attributes = .{ .utf8 = .{ .max_len = 12 } },
}, .{
    .name = "INSTALL_DIR_SAVEDATA_ADD_3",
    .description = "Title ID of the importable app by Save Data Transfer",
    .attributes = .{ .utf8 = .{ .max_len = 12 } },
}, .{
    .name = "INSTALL_DIR_SAVEDATA_ADD_4",
    .description = "Title ID of the importable app by Save Data Transfer",
    .attributes = .{ .utf8 = .{ .max_len = 12 } },
}, .{
    .name = "INSTALL_DIR_SAVEDATA_ADD_5",
    .description = "Title ID of the importable app by Save Data Transfer",
    .attributes = .{ .utf8 = .{ .max_len = 12 } },
}, .{
    .name = "INSTALL_DIR_SAVEDATA_ADD_6",
    .description = "Title ID of the importable app by Save Data Transfer",
    .attributes = .{ .utf8 = .{ .max_len = 12 } },
}, .{
    .name = "INSTALL_DIR_SAVEDATA_ADD_7",
    .description = "Title ID of the importable app by Save Data Transfer",
    .attributes = .{ .utf8 = .{ .max_len = 12 } },
}, .{
    .name = "SAVE_DATA_TRANSFER_TITLE_ID_LIST",
    .description = "Title IDs for Save Data Transfer",
    .attributes = .{ .utf8 = .{ .max_len = 512 } },
}, .{
    .name = "TITLE",
    .description = "***Name (Default Language)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "TITLE_00",
    .description = "***Name (Japanese)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "TITLE_01",
    .description = "***Name (English)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "TITLE_02",
    .description = "***Name (French)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "TITLE_03",
    .description = "***Name (Spanish)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "TITLE_04",
    .description = "***Name (German)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "TITLE_05",
    .description = "***Name (Italian)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "TITLE_06",
    .description = "***Name (Dutch)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "TITLE_07",
    .description = "***Name (Portuguese)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "TITLE_08",
    .description = "***Name (Russian)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "TITLE_09",
    .description = "***Name (Korean)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "TITLE_10",
    .description = "***Name (Trad.Chinese)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "TITLE_11",
    .description = "***Name (Simp.Chinese)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "TITLE_12",
    .description = "***Name (Finnish)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "TITLE_13",
    .description = "***Name (Swedish)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "TITLE_14",
    .description = "***Name (Danish)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "TITLE_15",
    .description = "***Name (Norwegian)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "TITLE_16",
    .description = "***Name (Polish)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "TITLE_17",
    .description = "***Name (Braz.Portuguese)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "TITLE_18",
    .description = "***Name (UK English)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "TITLE_19",
    .description = "***Name (Turkish)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "TITLE_20",
    .description = "***Name (Latin American Spanish)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "TITLE_21",
    .description = "***Name (Arabic)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "TITLE_22",
    .description = "***Name (Canadian French)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "TITLE_23",
    .description = "***Name (Czech)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "TITLE_24",
    .description = "***Name (Hungarian)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "TITLE_25",
    .description = "***Name (Greek)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "TITLE_26",
    .description = "***Name (Romanian)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "TITLE_27",
    .description = "***Name (Thai)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "TITLE_28",
    .description = "***Name (Vietnamese)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "TITLE_29",
    .description = "***Name (Indonesian)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "STITLE",
    .description = "***Short Name (Default Language)",
    .attributes = .{ .utf8 = .{ .max_len = 52 } },
}, .{
    .name = "STITLE_00",
    .description = "***Short Name (Japanese)",
    .attributes = .{ .utf8 = .{ .max_len = 52 } },
}, .{
    .name = "STITLE_01",
    .description = "***Short Name (English)",
    .attributes = .{ .utf8 = .{ .max_len = 52 } },
}, .{
    .name = "STITLE_02",
    .description = "***Short Name (French)",
    .attributes = .{ .utf8 = .{ .max_len = 52 } },
}, .{
    .name = "STITLE_03",
    .description = "***Short Name (Spanish)",
    .attributes = .{ .utf8 = .{ .max_len = 52 } },
}, .{
    .name = "STITLE_04",
    .description = "***Short Name (German)",
    .attributes = .{ .utf8 = .{ .max_len = 52 } },
}, .{
    .name = "STITLE_05",
    .description = "***Short Name (Italian)",
    .attributes = .{ .utf8 = .{ .max_len = 52 } },
}, .{
    .name = "STITLE_06",
    .description = "***Short Name (Dutch)",
    .attributes = .{ .utf8 = .{ .max_len = 52 } },
}, .{
    .name = "STITLE_07",
    .description = "***Short Name (Portuguese)",
    .attributes = .{ .utf8 = .{ .max_len = 52 } },
}, .{
    .name = "STITLE_08",
    .description = "***Short Name (Russian)",
    .attributes = .{ .utf8 = .{ .max_len = 52 } },
}, .{
    .name = "STITLE_09",
    .description = "***Short Name (Korean)",
    .attributes = .{ .utf8 = .{ .max_len = 52 } },
}, .{
    .name = "STITLE_10",
    .description = "***Short Name (Trad.Chinese)",
    .attributes = .{ .utf8 = .{ .max_len = 52 } },
}, .{
    .name = "STITLE_11",
    .description = "***Short Name (Simp.Chinese)",
    .attributes = .{ .utf8 = .{ .max_len = 52 } },
}, .{
    .name = "STITLE_12",
    .description = "***Short Name (Finnish)",
    .attributes = .{ .utf8 = .{ .max_len = 52 } },
}, .{
    .name = "STITLE_13",
    .description = "***Short Name (Swedish)",
    .attributes = .{ .utf8 = .{ .max_len = 52 } },
}, .{
    .name = "STITLE_14",
    .description = "***Short Name (Danish)",
    .attributes = .{ .utf8 = .{ .max_len = 52 } },
}, .{
    .name = "STITLE_15",
    .description = "***Short Name (Norwegian)",
    .attributes = .{ .utf8 = .{ .max_len = 52 } },
}, .{
    .name = "STITLE_16",
    .description = "***Short Name (Polish)",
    .attributes = .{ .utf8 = .{ .max_len = 52 } },
}, .{
    .name = "STITLE_17",
    .description = "***Short Name (Braz.Portuguese)",
    .attributes = .{ .utf8 = .{ .max_len = 52 } },
}, .{
    .name = "STITLE_18",
    .description = "***Short Name (UK English)",
    .attributes = .{ .utf8 = .{ .max_len = 52 } },
}, .{
    .name = "STITLE_19",
    .description = "***Short Name (Turkish)",
    .attributes = .{ .utf8 = .{ .max_len = 52 } },
}, .{
    .name = "STITLE_20",
    .description = "***Short Name (Latin American Spanish)",
    .attributes = .{ .utf8 = .{ .max_len = 52 } },
}, .{
    .name = "STITLE_21",
    .description = "***Short Name (Arabic)",
    .attributes = .{ .utf8 = .{ .max_len = 52 } },
}, .{
    .name = "STITLE_22",
    .description = "***Short Name (Canadian French)",
    .attributes = .{ .utf8 = .{ .max_len = 52 } },
}, .{
    .name = "STITLE_23",
    .description = "***Short Name (Czech)",
    .attributes = .{ .utf8 = .{ .max_len = 52 } },
}, .{
    .name = "STITLE_24",
    .description = "***Short Name (Hungarian)",
    .attributes = .{ .utf8 = .{ .max_len = 52 } },
}, .{
    .name = "STITLE_25",
    .description = "***Short Name (Greek)",
    .attributes = .{ .utf8 = .{ .max_len = 52 } },
}, .{
    .name = "STITLE_26",
    .description = "***Short Name (Romanian)",
    .attributes = .{ .utf8 = .{ .max_len = 52 } },
}, .{
    .name = "STITLE_27",
    .description = "***Short Name (Thai)",
    .attributes = .{ .utf8 = .{ .max_len = 52 } },
}, .{
    .name = "STITLE_28",
    .description = "***Short Name (Vietnamese)",
    .attributes = .{ .utf8 = .{ .max_len = 52 } },
}, .{
    .name = "STITLE_29",
    .description = "***Short Name (Indonesian)",
    .attributes = .{ .utf8 = .{ .max_len = 52 } },
}, .{
    .name = "PROVIDER",
    .description = "***Provider Name (Default Language)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "PROVIDER_00",
    .description = "***Provider Name (Japanese)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "PROVIDER_01",
    .description = "***Provider Name (English)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "PROVIDER_02",
    .description = "***Provider Name (French)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "PROVIDER_03",
    .description = "***Provider Name (Spanish)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "PROVIDER_04",
    .description = "***Provider Name (German)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "PROVIDER_05",
    .description = "***Provider Name (Italian)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "PROVIDER_06",
    .description = "***Provider Name (Dutch)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "PROVIDER_07",
    .description = "***Provider Name (Portuguese)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "PROVIDER_08",
    .description = "***Provider Name (Russian)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "PROVIDER_09",
    .description = "***Provider Name (Korean)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "PROVIDER_10",
    .description = "***Provider Name (Trad.Chinese)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "PROVIDER_11",
    .description = "***Provider Name (Simp.Chinese)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "PROVIDER_12",
    .description = "***Provider Name (Finnish)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "PROVIDER_13",
    .description = "***Provider Name (Swedish)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "PROVIDER_14",
    .description = "***Provider Name (Danish)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "PROVIDER_15",
    .description = "***Provider Name (Norwegian)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "PROVIDER_16",
    .description = "***Provider Name (Polish)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "PROVIDER_17",
    .description = "***Provider Name (Braz.Portuguese)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "PROVIDER_18",
    .description = "***Provider Name (UK English)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "PROVIDER_19",
    .description = "***Provider Name (Turkish)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "PROVIDER_20",
    .description = "***Provider Name (Latin American Spanish)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "PROVIDER_21",
    .description = "***Provider Name (Arabic)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "PROVIDER_22",
    .description = "***Provider Name (Canadian French)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "PROVIDER_23",
    .description = "***Provider Name (Czech)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "PROVIDER_24",
    .description = "***Provider Name (Hungarian)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "PROVIDER_25",
    .description = "***Provider Name (Greek)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "PROVIDER_26",
    .description = "***Provider Name (Romanian)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "PROVIDER_27",
    .description = "***Provider Name (Thai)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "PROVIDER_28",
    .description = "***Provider Name (Vietnamese)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "PROVIDER_29",
    .description = "***Provider Name (Indonesian)",
    .attributes = .{ .utf8 = .{ .max_len = 128 } },
}, .{
    .name = "IMPORT_SAVEDATA_INFO",
    .description = "Text info when importing Save Data (Default Language)",
    .attributes = .{ .utf8 = .{ .max_len = 1024 } },
    .flags = .{ .is_legacy = true },
}, .{
    .name = "IMPORT_SAVEDATA_INFO_00",
    .description = "Text info when importing Save Data (Japanese)",
    .attributes = .{ .utf8 = .{ .max_len = 1024 } },
    .flags = .{ .is_legacy = true },
}, .{
    .name = "IMPORT_SAVEDATA_INFO_01",
    .description = "Text info when importing Save Data (English)",
    .attributes = .{ .utf8 = .{ .max_len = 1024 } },
    .flags = .{ .is_legacy = true },
}, .{
    .name = "IMPORT_SAVEDATA_INFO_02",
    .description = "Text info when importing Save Data (French)",
    .attributes = .{ .utf8 = .{ .max_len = 1024 } },
    .flags = .{ .is_legacy = true },
}, .{
    .name = "IMPORT_SAVEDATA_INFO_03",
    .description = "Text info when importing Save Data (Spanish)",
    .attributes = .{ .utf8 = .{ .max_len = 1024 } },
    .flags = .{ .is_legacy = true },
}, .{
    .name = "IMPORT_SAVEDATA_INFO_04",
    .description = "Text info when importing Save Data (German)",
    .attributes = .{ .utf8 = .{ .max_len = 1024 } },
    .flags = .{ .is_legacy = true },
}, .{
    .name = "IMPORT_SAVEDATA_INFO_05",
    .description = "Text info when importing Save Data (Italian)",
    .attributes = .{ .utf8 = .{ .max_len = 1024 } },
    .flags = .{ .is_legacy = true },
}, .{
    .name = "IMPORT_SAVEDATA_INFO_06",
    .description = "Text info when importing Save Data (Dutch)",
    .attributes = .{ .utf8 = .{ .max_len = 1024 } },
    .flags = .{ .is_legacy = true },
}, .{
    .name = "IMPORT_SAVEDATA_INFO_07",
    .description = "Text info when importing Save Data (Portuguese)",
    .attributes = .{ .utf8 = .{ .max_len = 1024 } },
    .flags = .{ .is_legacy = true },
}, .{
    .name = "IMPORT_SAVEDATA_INFO_08",
    .description = "Text info when importing Save Data (Russian)",
    .attributes = .{ .utf8 = .{ .max_len = 1024 } },
    .flags = .{ .is_legacy = true },
}, .{
    .name = "IMPORT_SAVEDATA_INFO_09",
    .description = "Text info when importing Save Data (Korean)",
    .attributes = .{ .utf8 = .{ .max_len = 1024 } },
    .flags = .{ .is_legacy = true },
}, .{
    .name = "IMPORT_SAVEDATA_INFO_10",
    .description = "Text info when importing Save Data (Trad.Chinese)",
    .attributes = .{ .utf8 = .{ .max_len = 1024 } },
    .flags = .{ .is_legacy = true },
}, .{
    .name = "IMPORT_SAVEDATA_INFO_11",
    .description = "Text info when importing Save Data (Simp.Chinese)",
    .attributes = .{ .utf8 = .{ .max_len = 1024 } },
    .flags = .{ .is_legacy = true },
}, .{
    .name = "IMPORT_SAVEDATA_INFO_12",
    .description = "Text info when importing Save Data (Finnish)",
    .attributes = .{ .utf8 = .{ .max_len = 1024 } },
    .flags = .{ .is_legacy = true },
}, .{
    .name = "IMPORT_SAVEDATA_INFO_13",
    .description = "Text info when importing Save Data (Swedish)",
    .attributes = .{ .utf8 = .{ .max_len = 1024 } },
    .flags = .{ .is_legacy = true },
}, .{
    .name = "IMPORT_SAVEDATA_INFO_14",
    .description = "Text info when importing Save Data (Danish)",
    .attributes = .{ .utf8 = .{ .max_len = 1024 } },
    .flags = .{ .is_legacy = true },
}, .{
    .name = "IMPORT_SAVEDATA_INFO_15",
    .description = "Text info when importing Save Data (Norwegian)",
    .attributes = .{ .utf8 = .{ .max_len = 1024 } },
    .flags = .{ .is_legacy = true },
}, .{
    .name = "IMPORT_SAVEDATA_INFO_16",
    .description = "Text info when importing Save Data (Polish)",
    .attributes = .{ .utf8 = .{ .max_len = 1024 } },
    .flags = .{ .is_legacy = true },
}, .{
    .name = "IMPORT_SAVEDATA_INFO_17",
    .description = "Text info when importing Save Data (Braz.Portuguese)",
    .attributes = .{ .utf8 = .{ .max_len = 1024 } },
    .flags = .{ .is_legacy = true },
}, .{
    .name = "IMPORT_SAVEDATA_INFO_18",
    .description = "Text info when importing Save Data (UK English)",
    .attributes = .{ .utf8 = .{ .max_len = 1024 } },
    .flags = .{ .is_legacy = true },
}, .{
    .name = "IMPORT_SAVEDATA_INFO_19",
    .description = "Text info when importing Save Data (Turkish)",
    .attributes = .{ .utf8 = .{ .max_len = 1024 } },
    .flags = .{ .is_legacy = true },
}, .{
    .name = "IMPORT_SAVEDATA_INFO_20",
    .description = "Text info when importing Save Data (Latin American Spanish)",
    .attributes = .{ .utf8 = .{ .max_len = 1024 } },
    .flags = .{ .is_legacy = true },
}, .{
    .name = "IMPORT_SAVEDATA_INFO_21",
    .description = "Text info when importing Save Data (Arabic)",
    .attributes = .{ .utf8 = .{ .max_len = 1024 } },
    .flags = .{ .is_legacy = true },
}, .{
    .name = "IMPORT_SAVEDATA_INFO_22",
    .description = "Text info when importing Save Data (Canadian French)",
    .attributes = .{ .utf8 = .{ .max_len = 1024 } },
    .flags = .{ .is_legacy = true },
}, .{
    .name = "IMPORT_SAVEDATA_INFO_23",
    .description = "Text info when importing Save Data (Czech)",
    .attributes = .{ .utf8 = .{ .max_len = 1024 } },
    .flags = .{ .is_legacy = true },
}, .{
    .name = "IMPORT_SAVEDATA_INFO_24",
    .description = "Text info when importing Save Data (Hungarian)",
    .attributes = .{ .utf8 = .{ .max_len = 1024 } },
    .flags = .{ .is_legacy = true },
}, .{
    .name = "IMPORT_SAVEDATA_INFO_25",
    .description = "Text info when importing Save Data (Greek)",
    .attributes = .{ .utf8 = .{ .max_len = 1024 } },
    .flags = .{ .is_legacy = true },
}, .{
    .name = "IMPORT_SAVEDATA_INFO_26",
    .description = "Text info when importing Save Data (Romanian)",
    .attributes = .{ .utf8 = .{ .max_len = 1024 } },
    .flags = .{ .is_legacy = true },
}, .{
    .name = "IMPORT_SAVEDATA_INFO_27",
    .description = "Text info when importing Save Data (Thai)",
    .attributes = .{ .utf8 = .{ .max_len = 1024 } },
    .flags = .{ .is_legacy = true },
}, .{
    .name = "IMPORT_SAVEDATA_INFO_28",
    .description = "Text info when importing Save Data (Vietnamese)",
    .attributes = .{ .utf8 = .{ .max_len = 1024 } },
    .flags = .{ .is_legacy = true },
}, .{
    .name = "IMPORT_SAVEDATA_INFO_29",
    .description = "Text info when importing Save Data (Indonesian)",
    .attributes = .{ .utf8 = .{ .max_len = 1024 } },
    .flags = .{ .is_legacy = true },
} };
