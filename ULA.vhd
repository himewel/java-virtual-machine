library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is
	generic (
		DATA_WIDTH: natural:= 8
	);
	
	port (
		clk: in std_logic;
		enable: in std_logic;
		op		: in std_logic_vector(1 downto 0);
		op1	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		op2	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		outOp	: out std_logic_vector(DATA_WIDTH-1 downto 0);
		greater_then: out std_logic;
		less_then: out std_logic;
		equal	: out std_logic;
		Aa: out std_logic_vector(DATA_WIDTH-1 downto 0);
		Bb: out std_logic_vector(DATA_WIDTH-1 downto 0)
	);
end entity;

architecture rtl of ULA is

signal opA	: std_logic_vector(DATA_WIDTH-1 downto 0);
signal opB	: std_logic_vector(DATA_WIDTH-1 downto 0);

begin

Aa <= opA;
Bb <= opB;

	opA <= op1;
	opB <= op2;

	outOp <= std_logic_vector(resize(unsigned(opA) * unsigned(opB),DATA_WIDTH)) when op(1) = '1' else
		std_logic_vector(unsigned(opA) - unsigned(opB)) when op(0) = '1' else
		std_logic_vector(unsigned(opA) + unsigned(opB));
	greater_then <= '1' when opA > opB else '0';
	less_then <= '1' when opA < opB else '0';
	equal <= '1' when opA = opB else '0';
	
end rtl;