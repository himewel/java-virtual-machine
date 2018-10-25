library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BRANCH is
	generic (
		DATA_WIDTH: natural:= 8;
		ADDR_WIDTH: natural:= 12
	);
	
	port (
		clk: in std_logic;
		branch_in: in std_logic_vector(DATA_WIDTH-1 downto 0);
		opBranch : in std_logic;
		selecBranch: in std_logic_vector(2 downto 0);
		outAddr: out std_logic_vector(ADDR_WIDTH-1 downto 0)
	);
end entity;

architecture rtl of BRANCH is
signal branch1	: std_logic_vector(DATA_WIDTH-1 downto 0);
signal branch2	: std_logic_vector(DATA_WIDTH-1 downto 0);
signal branch3	: std_logic_vector(DATA_WIDTH-1 downto 0);
signal branch4	: std_logic_vector(DATA_WIDTH-1 downto 0);
begin
	process (clk)
	begin
		if (rising_edge(clk)) then
			if (selecBranch(2) = '1') then
				if (selecBranch(1 downto 0) = "00") then
					branch1 <= branch_in;
				elsif (selecBranch(1 downto 0) = "01") then
					branch2 <= branch_in;
				elsif (selecBranch(1 downto 0) = "10") then
					branch3 <= branch_in;
				else
					branch4 <= branch_in;
				end if;
			end if;
		end if;
	end process;

--outAddr <= (std_logic_vector(to_unsigned(0,ADDR_WIDTH/2)) & branch1 & branch2) when opBranch = '0' else
--(branch1 & branch2 & branch3 & branch4);
outAddr <= (branch1 & branch2(3 downto 0)) when opBranch = '0' else
(branch1((ADDR_WIDTH/4)-1 downto 0) & branch2((ADDR_WIDTH/4)-1 downto 0) & branch3((ADDR_WIDTH/4)-1 downto 0) & branch4((ADDR_WIDTH/4)-1 downto 0));

end rtl;