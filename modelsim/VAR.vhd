-- Quartus II VHDL Template
-- Single-port RAM with single read/write address and initial contents

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VAR is

	generic
	(
		DATA_WIDTH : natural;
		ADDR_WIDTH : natural
	);

	port
	(
		clk		: in std_logic;
		addr	: in integer range 0 to 2**ADDR_WIDTH - 1;
		data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic;
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);

end VAR;

architecture rtl of VAR is

	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;

	-- Declare the RAM signal and specify a default value.	Quartus II
	-- will create a memory initialization file (.mif) based on the
	-- default value.
	signal ram : memory_t;

	-- Register to hold the address
	signal addr_reg : natural range 0 to 2**ADDR_WIDTH-1;

begin

	process(clk)
	begin
	if(rising_edge(clk)) then
		if(we = '1') then
			ram(addr) <= data;
		end if;

		-- Register the address for reading
		addr_reg <= addr;
	end if;
	end process;

	q <= ram(addr_reg);

end rtl;