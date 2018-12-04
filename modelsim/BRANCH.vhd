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

outAddr <= branch1 & branch2 when opBranch = '0' else
    branch1(3 downto 0) & branch2(3 downto 0) & branch3(3 downto 0) & branch4(3 downto 0);

	--process (clk)
	--begin
	--	if (ADDR_WIDTH = 32) then
	--		if (opBranch = '0') then
	--			outAddr <= std_logic_vector(to_unsigned(0,ADDR_WIDTH/2)) & branch1 & branch2;
	--		else
	--			outAddr <= branch1 & branch2 & branch3 & branch4;
	--		end if;
	--	elsif (ADDR_WIDTH = 16) then
	--	if (opBranch = '0') then
	--			outAddr <= branch1 & branch2;
	--	else
	--			outAddr <= branch1(3 downto 0) & branch2(3 downto 0) & branch3(3 downto 0) & branch4(3 downto 0);
	--  end if;
	--	elsif (ADDR_WIDTH = 12) then
	--		if (opBranch = '0') then
	--			outAddr <= branch1(5 downto 0) & branch2(5 downto 0);
	--		else
	--			outAddr <= branch1(2 downto 0) & branch2(2 downto 0) & branch3(2 downto 0) & branch4(2 downto 0);
	--		end if;
	--	else
	--		if (opBranch = '0') then
	--			outAddr <= branch1(3 downto 0) & branch2(3 downto 0);
	--		else
	--			outAddr <= branch1(1 downto 0) & branch2(1 downto 0) & branch3(1 downto 0) & branch4(1 downto 0);
	--		end if;
	--	end if;
	--end process;

end rtl;
