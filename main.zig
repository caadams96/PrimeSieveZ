const std = @import("std");

pub fn main() !void {
    const start = std.time.milliTimestamp();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};

    var sieve = try Sieve().init(gpa.allocator(), 1_000_000_000);
    try sieve.sift();
    try sieve.count_primes();
    sieve.print_prime_count();
    const stop = std.time.milliTimestamp();
    std.debug.print("Elapsed time: {} ms\n", .{stop - start});
}
fn Sieve() type {
    return struct {
        const This = @This();
        gpa: std.mem.Allocator,
        memory: []bool,
        size: usize,
        prime_count: usize,

        pub fn init(gpa: std.mem.Allocator, size: usize) !This {
            return This{
                .gpa = gpa,
                .memory = try gpa.alloc(bool, size),
                .size = size,
                .prime_count = 0,
            };
        }

        pub fn sift(this: *This) !void {
            this.fill();
            this.memory[0] = false;
            this.memory[1] = false;
            var x: usize = 2;
            var i: usize = 0;
            while (x * x <= this.size) : (x += 1) {
                const prime: bool = this.memory[x];
                if (prime) {
                    i = x * x;
                    while (i < this.size) : (i += x) {
                        this.memory[i] = false;
                    }
                }
            }
        }

        pub fn print_sieve(this: *This) void {
            for (this.memory, 0..) |prime, i| {
                if (prime) {
                    std.debug.print("Index {}: {}\n", .{ i, prime });
                }
            }
        }
        pub fn print_prime_count(this: *This) void {
            std.debug.print("Primes found: {}\n", .{this.prime_count});
        }
        pub fn count_primes(this: *This) !void {
            for (this.memory) |prime| {
                if (prime) {
                    this.prime_count += 1;
                }
            }
        }
        // Private Methods
        fn fill(this: *This) void {
            for (this.memory) |*z| {
                z.* = true;
            }
        }
    };
}
