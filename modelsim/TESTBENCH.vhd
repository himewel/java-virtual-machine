library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TESTBENCH is
    generic (
        DATA_WIDTH_EXT : natural := 8;
        ADDR_WIDTH_EXT : natural := 16;
        ADDR_VAR_WIDTH_EXT	: natural := 5
    );
end entity;

architecture rtl of TESTBENCH is

    component Main is
        generic (
            DATA_WIDTH_EXT : natural;
            ADDR_WIDTH_EXT : natural;
            ADDR_VAR_WIDTH_EXT	: natural
        );
        port (
    		clk_externo   : in std_logic;
    		rst_externo   : in std_logic;
    		pc_counter    : out std_logic_vector(ADDR_WIDTH_EXT-1 downto 0);
    		data_out      : out std_logic_vector(DATA_WIDTH_EXT-1 downto 0);
    		stack_in      : out std_logic_vector(DATA_WIDTH_EXT-1 downto 0);
    		stack_out     : out std_logic_vector(DATA_WIDTH_EXT-1 downto 0);
    		ula_out       : out std_logic_vector(DATA_WIDTH_EXT-1 downto 0);
    		a             : out std_logic_vector(DATA_WIDTH_EXT-1 downto 0);
    		b             : out std_logic_vector(DATA_WIDTH_EXT-1 downto 0);
    		out_addr      : out std_logic_vector(ADDR_WIDTH_EXT-1 downto 0);
    		igual         : out std_logic;
    		maior         : out std_logic;
    		menor         : out std_logic;
    		jump_out      : out std_logic
    	);
    end component;

    signal clk,rst,eq,gt,lt,jmp: std_logic := '0';
    signal pc,addr: std_logic_vector(ADDR_WIDTH_EXT-1 downto 0);
    signal out_mem,in_stack,out_stack,ula,p1,p2: std_logic_vector(DATA_WIDTH_EXT-1 downto 0);

begin

    DUT: Main
        generic map (
            DATA_WIDTH_EXT => DATA_WIDTH_EXT,
            ADDR_WIDTH_EXT => ADDR_WIDTH_EXT,
            ADDR_VAR_WIDTH_EXT => ADDR_VAR_WIDTH_EXT
        )
        port map (
            clk_externo	=> clk,
            rst_externo => rst,
            pc_counter	=> pc,
            data_out	=> out_mem,
            stack_in    => in_stack,
            stack_out	=> out_stack,
            ula_out     => ula,
            a           => p1,
            b           => p2,
            out_addr    => addr,
            igual       => eq,
            maior       => gt,
            menor       => lt,
            jump_out    => jmp
    );

    process
    begin
    	wait for 10 ns;
    	clk <= not clk;
    end process;

    --rst <= '1' after  ns, '0' after 100 ns;

end rtl;
