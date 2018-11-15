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
		op 		: in std_logic;
		rst 	: in std_logic;
		jmp		: in std_logic;
		inPC	: in std_logic_vector(ADDR_WIDTH-1 downto 0);
		outPC	: out std_logic_vector(ADDR_WIDTH-1 downto 0)
	);
end entity;

architecture rtl of PC is
signal pc: signed(ADDR_WIDTH-1 downto 0);
begin

outPC <= std_logic_vector(pc);

	process (enable,rst)
	begin
		if (rst = '1') then
			pc <= to_signed(0,ADDR_WIDTH);
		elsif (rising_edge(enable)) then
			if (op = '0') then
				pc <= pc + 1;
			else
				pc <= pc + 2;
			end if;
			if (jmp = '1') then
				pc <= signed(inPC);
			end if;
		end if;
	end process;

end rtl;
