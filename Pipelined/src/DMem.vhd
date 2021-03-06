library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity DMem is 
	generic (
		DataWidth:    integer := 32;
		Capacity:     integer := 256
	);
	port(
		clk, WE: in STD_LOGIC;
		A, WD: in STD_LOGIC_VECTOR(DataWidth - 1 DOWNTO 0);
		RD: out STD_LOGIC_VECTOR(DataWidth - 1 DOWNTO 0)
	);
end DMem;

architecture Behavioral of DMem is 
	TYPE   RamType is array(0 TO Capacity - 1) of STD_LOGIC_VECTOR(DataWidth - 1 DOWNTO 0);
	SIGNAL RAM: RamType := (others => (others => '0'));
begin
	process(clk, A) begin
		if (rising_edge(clk)) then 
			if(WE = '1') then 
			     RAM(TO_INTEGER(UNSIGNED(A(7 DOWNTO 0))) / 4) <= WD;
            end if;
		end if;
		RD <= RAM(TO_INTEGER(UNSIGNED(A(7 DOWNTO 0))) / 4);
	end process;
end Behavioral;