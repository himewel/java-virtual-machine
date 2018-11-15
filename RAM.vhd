-- Quartus II VHDL Template
-- Single-port RAM with single read/write address and initial contents

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM is
	generic (
		DATA_WIDTH : natural := 8;
		ADDR_WIDTH : natural := 12
	);
	port (
		clk		: in std_logic;
		addr	: in natural range 0 to 2**ADDR_WIDTH-1;
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0);
		q1		: out std_logic_vector((DATA_WIDTH -1) downto 0);
		q2		: out std_logic_vector((DATA_WIDTH -1) downto 0);
		q3		: out std_logic_vector((DATA_WIDTH -1) downto 0);
		q4		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);
end RAM;

architecture rtl of RAM is
	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;

	function init_ram
		return memory_t is
		variable tmp : memory_t := (others => (others => '0'));
	begin
		for addr_pos in 0 to 2**ADDR_WIDTH - 1 loop
			-- Initialize each address with the address itself
			tmp(addr_pos) := std_logic_vector(to_unsigned(0, DATA_WIDTH));
		end loop;
		--tmp(0) := "00010000"; -- bipush
		--tmp(1) := "00000010"; -- 2
		--tmp(2) := "01010001"; -- istore_<1>
		--tmp(3) := "00010000"; -- bipush
		--tmp(4) := "00000100"; -- 4
		--tmp(5) := "01010010"; -- istore_<2>
		--tmp(6) := "00100001"; -- iload_<1>
		--tmp(7) := "00100010"; -- iload_<2>
		--tmp(8) := "01100000"; -- iadd
		--tmp(9) := "01010011"; -- istore_<3>
		--tmp(10) := "10000000"; -- NOP

		tmp(0) := "00010000"; -- bipush
		tmp(1) := "00000010"; -- 2
		tmp(2) := "00010000"; -- bipush
		tmp(3) := "00000011"; -- 3
		tmp(4) := "10101111"; -- if_icmpEQ
		tmp(5) := "00000000"; --
		tmp(6) := "00000000"; --
		tmp(7) := "10000000"; -- NOP
		return tmp;
	end init_ram;

	-- Declare the RAM signal and specify a default value.	Quartus II
	-- will create a memory initialization file (.mif) based on the
	-- default value.
	signal ram : memory_t := init_ram;

	-- Register to hold the address
	signal addr_reg : integer range 0 to 2**ADDR_WIDTH-1;

begin

	process(clk)
	begin
	if(rising_edge(clk)) then
		-- Register the address for reading
		addr_reg <= addr;
	end if;
	end process;

	q <= ram(addr_reg);
	q1 <= ram(addr_reg+1);
	q2 <= ram(addr_reg+2);
	q3 <= ram(addr_reg+3);
	q4 <= ram(addr_reg+4);

end rtl;
