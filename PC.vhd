library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
	generic 
	(
		DATA_WIDTH : natural := 8;
		ADDR_WIDTH : natural := 12
	);

	port (
		enable 	: in std_logic;
		rst 		: in std_logic;
		jmp		: in std_logic;
		inPC : in std_logic_vector(ADDR_WIDTH-1 downto 0);
		outPC : out std_logic_vector(ADDR_WIDTH-1 downto 0)
	);
end entity;

architecture rtl of PC is
signal pc: signed(ADDR_WIDTH-1 downto 0);
begin

outPC <= std_logic_vector(pc);

	process (enable)
	begin
		if (rising_edge(enable)) then
			if (rst = '1') then
				pc <= to_signed(0,ADDR_WIDTH);
			end if;
			if (jmp = '1') then
				pc <= signed(inPC);
			else
				pc <= pc + 1;
			end if;
		end if;
	end process;
end rtl;