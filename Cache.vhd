library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Cache is
	port (
		clk		: in std_logic;
		rst		: in std_logic;
		enable	: in std_logic;
		readSig	: in std_logic;
		writeSig	: in std_logic;
		inMem		: in std_logic_vector(7 downto 0);
		address	: in std_logic_vector(7 downto 0);
		outMem 	: out std_logic_vector(7 downto 0);
		oMem0		: out signed(7 downto 0);
		oMem1		: out signed(7 downto 0);
		oMem2		: out signed(7 downto 0);
		oMem3		: out signed(7 downto 0);
		oMem4		: out signed(7 downto 0);
		oMem5		: out signed(7 downto 0);
		oMem6		: out signed(7 downto 0);
		oMem7		: out signed(7 downto 0);
		oMem8		: out signed(7 downto 0);
		oMem9		: out signed(7 downto 0);
		oMem10		: out signed(7 downto 0);
		oMem11		: out signed(7 downto 0);
		oMem12		: out signed(7 downto 0);
		oMem13		: out signed(7 downto 0);
		oMem14		: out signed(7 downto 0)
	);
end entity;

architecture rtl of Cache is
signal mem0: signed(7 downto 0);
signal mem1: signed(7 downto 0);
signal mem2: signed(7 downto 0);
signal mem3: signed(7 downto 0);
signal mem4: signed(7 downto 0);
signal mem5: signed(7 downto 0);
signal mem6: signed(7 downto 0);
signal mem7: signed(7 downto 0);
signal mem8: signed(7 downto 0);
signal mem9: signed(7 downto 0);
signal mem10: signed(7 downto 0);
signal mem11: signed(7 downto 0);
signal mem12: signed(7 downto 0);
signal mem13: signed(7 downto 0);
signal mem14: signed(7 downto 0);
begin

oMem0 <= mem0;
oMem1 <= mem1;
oMem2 <= mem2;
oMem3 <= mem3;
oMem4 <= mem4;
oMem5 <= mem5;
oMem6 <= mem6;
oMem7 <= mem7;
oMem8 <= mem8;
oMem9 <= mem9;
oMem10 <= mem10;
oMem11 <= mem11;
oMem12 <= mem12;
oMem13 <= mem13;
oMem14 <= mem14;

	process (clk)
	begin
		if (rising_edge(clk)) then
			if (rst = '1') then
				mem0 <= to_signed(0,8);
				mem1 <= to_signed(0,8);
				mem2 <= to_signed(0,8);
				mem3 <= to_signed(0,8);
				mem4 <= to_signed(0,8);
				mem5 <= to_signed(0,8);
				mem6 <= to_signed(0,8);
				mem7 <= to_signed(0,8);
				mem8 <= to_signed(0,8);
				mem9 <= to_signed(0,8);
				mem10 <= to_signed(0,8);
				mem11 <= to_signed(0,8);
				mem12 <= to_signed(0,8);
				mem13 <= to_signed(0,8);
				mem14 <= to_signed(0,8);
			end if;
			if (enable = '1') then
				if (writeSig = '1') then
					if (address = std_logic_vector(to_signed(0,8))) then
						mem0 <= signed(inMem);
					elsif (address = std_logic_vector(to_signed(1,8))) then
						mem1 <= signed(inMem);
					elsif (address = std_logic_vector(to_signed(2,8))) then
						mem2 <= signed(inMem);
					elsif (address = std_logic_vector(to_signed(3,8))) then
						mem3 <= signed(inMem);
					elsif (address = std_logic_vector(to_signed(4,8))) then
						mem4 <= signed(inMem);
					elsif (address = std_logic_vector(to_signed(5,8))) then
						mem5 <= signed(inMem);
					elsif (address = std_logic_vector(to_signed(6,8))) then
						mem6 <= signed(inMem);
					elsif (address = std_logic_vector(to_signed(7,8))) then
						mem7 <= signed(inMem);
					elsif (address = std_logic_vector(to_signed(8,8))) then
						mem8 <= signed(inMem);
					elsif (address = std_logic_vector(to_signed(9,8))) then
						mem9 <= signed(inMem);
					elsif (address = std_logic_vector(to_signed(10,8))) then
						mem10 <= signed(inMem);
					elsif (address = std_logic_vector(to_signed(11,8))) then
						mem11 <= signed(inMem);
					elsif (address = std_logic_vector(to_signed(12,8))) then
						mem12 <= signed(inMem);
					elsif (address = std_logic_vector(to_signed(13,8))) then
						mem13 <= signed(inMem);
					else
						mem14 <= signed(inMem);
					end if;
				end if;
				if (readSig = '1') then
					if (address = std_logic_vector(to_signed(0,8))) then
						outMem <= std_logic_vector(mem0);
					elsif (address = std_logic_vector(to_signed(1,8))) then
						outMem <= std_logic_vector(mem1);
					elsif (address = std_logic_vector(to_signed(2,8))) then
						outMem <= std_logic_vector(mem2);
					elsif (address = std_logic_vector(to_signed(3,8))) then
						outMem <= std_logic_vector(mem3);
					elsif (address = std_logic_vector(to_signed(4,8))) then
						outMem <= std_logic_vector(mem4);
					elsif (address = std_logic_vector(to_signed(5,8))) then
						outMem <= std_logic_vector(mem5);
					elsif (address = std_logic_vector(to_signed(6,8))) then
						outMem <= std_logic_vector(mem6);
					elsif (address = std_logic_vector(to_signed(7,8))) then
						outMem <= std_logic_vector(mem7);
					elsif (address = std_logic_vector(to_signed(8,8))) then
						outMem <= std_logic_vector(mem8);
					elsif (address = std_logic_vector(to_signed(9,8))) then
						outMem <= std_logic_vector(mem9);
					elsif (address = std_logic_vector(to_signed(10,8))) then
						outMem <= std_logic_vector(mem10);
					elsif (address = std_logic_vector(to_signed(11,8))) then
						outMem <= std_logic_vector(mem11);
					elsif (address = std_logic_vector(to_signed(12,8))) then
						outMem <= std_logic_vector(mem12);
					elsif (address = std_logic_vector(to_signed(13,8))) then
						outMem <= std_logic_vector(mem13);
					else
						outMem <= std_logic_vector(mem14);
					end if;
				end if;
			end if;
		end if;
	end process;
end rtl;