library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BRANCH is
	generic (
		DATA_WIDTH: natural;
		ADDR_WIDTH: natural
	);
	port (
		clk: in std_logic;
		branch_in1: in std_logic_vector(DATA_WIDTH-1 downto 0);
		branch_in2: in std_logic_vector(DATA_WIDTH-1 downto 0);
		selec_in: in std_logic;
		opBranch : in std_logic;
		outAddr: out std_logic_vector(ADDR_WIDTH-1 downto 0)
	);
end entity;

architecture rtl of BRANCH is
	signal branch1,branch2,branch3,branch4: std_logic_vector(DATA_WIDTH-1 downto 0);

begin
	process (clk)
	begin
		if (rising_edge(clk)) then
			if (selec_in = '0') then
				branch1 <= branch_in1;
				branch2 <= branch_in2;
			else
				branch3 <= branch_in1;
				branch4 <= branch_in2;
			end if;
		end if;
	end process;

outAddr <= (std_logic_vector(to_unsigned(0,ADDR_WIDTH/2)) & branch1 & branch2) when opBranch = '0' else
(branch1 & branch2 & branch3 & branch4);

--outAddr <= (branch1 & branch2(3 downto 0)) when opBranch = '0' else
--(branch1((ADDR_WIDTH/4)-1 downto 0) & branch2((ADDR_WIDTH/4)-1 downto 0) & branch3((ADDR_WIDTH/4)-1 downto 0) & branch4((ADDR_WIDTH/4)-1 downto 0));

--outAddr <= (branch1(3 downto 0) & branch2(3 downto 0)) when opBranch = '0' else
--(branch1((ADDR_WIDTH/4)-1 downto 0) & branch2((ADDR_WIDTH/4)-1 downto 0) & branch3((ADDR_WIDTH/4)-1 downto 0) & branch4((ADDR_WIDTH/4)-1 downto 0));

end rtl;
