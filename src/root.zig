pub const gp4 = @import("gp4.zig");
pub const sfo = @import("sfo.zig");

test {
    // force reference for tests
    _ = &gp4;
    _ = &sfo;
}
