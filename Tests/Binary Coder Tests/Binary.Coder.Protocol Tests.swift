import Binary_Integer_Coder
import Binary_Parser_Test_Support
import Either
import Testing

@testable import Binary_Coder

@Suite struct `Binary.Coder.Protocol Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `Binary.Coder.Protocol Tests`.Unit {

    @Test
    func `parse via Coder.Protocol surface decodes complete input`() throws {
        let coder = Binary.Coder.machine(
            Binary.Machine.u8Parser(),
            encode: { value, output in output.append(Byte(value)) }
        )
        var input = ArraySlice<Byte>([0x42])

        let value = try coder.parse(&input)

        #expect(value == 0x42)
    }

    @Test
    func `serialize via Coder.Protocol surface appends bytes to buffer`() throws {
        let coder = Binary.Coder.machine(
            Binary.Machine.u8Parser(),
            encode: { value, output in output.append(Byte(value)) }
        )
        var buffer: [Byte] = [0x00, 0x01]

        try coder.serialize(0x42, into: &buffer)

        #expect(buffer == [0x00, 0x01, 0x42])
    }

    @Test
    func `round-trip via Coder.Protocol surface preserves value`() throws {
        let coder = Binary.Coder.machine(
            Binary.Machine.u8Parser(),
            encode: { value, output in output.append(Byte(value)) }
        )

        var buffer: [Byte] = []
        try coder.serialize(0xAB, into: &buffer)

        var input = buffer[...]
        let reparsed = try coder.parse(&input)

        #expect(reparsed == 0xAB)
    }
}

extension `Binary.Coder.Protocol Tests`.`Edge Case` {

    @Test
    func `parse via Coder.Protocol surface throws Either left on empty input`() throws {
        let coder = Binary.Coder.machine(
            Binary.Machine.u8Parser(),
            encode: { value, output in output.append(Byte(value)) }
        )
        var input = ArraySlice<Byte>([])

        do throws(Either<Binary.Machine.Fault, Never>) {
            _ = try coder.parse(&input)
            Issue.record("Expected parse to throw on empty input")
        } catch {

            let fault: Binary.Machine.Fault = error.value
            _ = fault
        }
    }
}
