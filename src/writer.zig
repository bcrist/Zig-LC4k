pub fn Checksum_Hasher(comptime T: type) type {
    return struct {
        sum: T,

        pub fn update(self: *@This(), buf: []const u8) void {
            var checksum = self.sum;
            for (buf) |b| checksum +%= b;
            self.sum = checksum;
        }
    };
}

pub fn checksummed(w: *std.Io.Writer, initial_checksum: anytype, buffer: []u8) std.Io.Writer.Hashed(Checksum_Hasher(@TypeOf(initial_checksum))) {
    const T = @TypeOf(initial_checksum);
    return std.Io.Writer.hashed(w, Checksum_Hasher(T) { .sum = initial_checksum }, buffer);
}

const std = @import("std");
