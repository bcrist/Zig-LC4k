pub fn Checksum_Writer(comptime T: type) type {
    return struct {
        inner: std.io.AnyWriter,
        checksum: *T,

        const Self = @This();

        pub fn any(self: *Self) std.io.AnyWriter {
            return .{
                .context = self,
                .writeFn = write,
            };
        }

        pub fn write(context: *const anyopaque, bytes: []const u8) anyerror!usize {
            const self: *const Self = @alignCast(@ptrCast(context));
            const bytes_written = try self.inner.writeFn(self.inner.context, bytes);
            var checksum = self.checksum.*;
            for (bytes[0..bytes_written]) |b| {
                checksum +%= b;
            }
            self.checksum.* = checksum;
            return bytes_written;
        }
    };
}
pub fn checksum_writer(comptime T: type, checksum: *T, inner: std.io.AnyWriter) Checksum_Writer(T) {
    return .{
        .inner = inner,
        .checksum = checksum,
    };
}

const std = @import("std");
