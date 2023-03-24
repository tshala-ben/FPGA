----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:50:10 03/16/2021 
-- Design Name: 
-- Module Name:    affichage_7_segments - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
-- Packages
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity affichage7segments is
 generic (
            N :  std_logic_vector:=x"5F5E0FF"; -- count from 0 to M-1
            M : integer := 26   -- M bits required to count upto N i.e. 2**M >= N
    );
    
    Port ( clk_in : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           an : out  STD_LOGIC_VECTOR (3 downto 0);
           sseg : out  STD_LOGIC_VECTOR (7 downto 0)
			  );
end affichage7segments;

architecture Behavioral of affichage_7_segments is


 signal temp: std_logic_vector(0 to 3);
	  signal one_sec_counter: std_logic_vector(M downto 0);
	  signal one_sec_en: std_logic;
	  signal bcd: std_logic_vector(3 downto 0);
begin
		-- One second Pulse or tick
		process(clk_in,rst)
		begin
				if rst='1' then 
						one_sec_counter <= (others=>'0');
				elsif rising_edge(clk_in) then
						if one_sec_counter=N then
								one_sec_counter <= (others=>'0');
						else 
								one_sec_counter <= one_sec_counter +"1";
						end if;
				end if;
		end process;
		one_sec_en <= '1' when one_sec_counter=N else '0';
	   
		-- BCD counter
		process(clk_in,rst)
		variable var1 : integer := 0;
		variable var2 : integer := 0; 
		variable var3 : integer := 0; 
		begin
				if rst='1' then
						bcd<=(others=>'0');
				elsif rising_edge(clk_in) then
						if one_sec_en='1' then 
								if bcd(3 downto 0)="1001" then
										bcd<=(others=>'0');
										 var1<=var1+1;
								
								if var1=10 then
								var2 <= var2+1;
								var1<=0;
								end if;
								if var2=10 then
								var3 <= var3+1;
								var2<=0;
								end if;
								if  var3=10 then
								var3<=0;
								end if;
							else
										bcd<=bcd +"1";
								
								
						end if;
				end if;
				end if;
		end process;
		
		-- Seven Segment display
		an<="0000";
		with bcd select
				ssegu(6 downto 0)<=
						--abcdefg
						"0000001" when "0000",                       --0
						"1001111" when "0001",                       --1
						"0010010" when "0010" ,                      --2
						"0000110" when "0011",                       --3
						"1001100" when "0100" ,                      --4
						"0100100" when "0101",                       --5
						"0100000" when "0110" ,                      --6
						"0001111" when "0111",                       --7
						"0000000" when "1000" ,                      --8
						"0000100" when "1001",                       --9
					
						"0000001" when others;                        --F
			ssegu(7) <= '1';
			with var1 select
				ssegd(6 downto 0)<=
						--abcdefg
						"0000001" when 0 ,                       --0
						"1001111" when 1,                       --1
						"0010010" when 2 ,                      --2
						"0000110" when 3,                       --3
						"1001100" when 4 ,                      --4
						"0100100" when 5,                       --5
						"0100000" when 6 ,                      --6
						"0001111" when 7,                       --7
						"0000000" when 8 ,                      --8
						"0000100" when 9,                       --9
						"0000001" when others;                        --0
			ssegd(7) <= '1';with var2 select
				ssegc(6 downto 0)<=
						--abcdefg
						"0000001" when 0 ,                       --0
						"1001111" when 1,                       --1
						"0010010" when 2 ,                      --2
						"0000110" when 3,                       --3
						"1001100" when 4 ,                      --4
						"0100100" when 5,                       --5
						"0100000" when 6 ,                      --6
						"0001111" when 7,                       --7
						"0000000" when 8 ,                      --8
						"0000100" when 9,                       --9
						"0000001" when others;                        --0
			ssegc(7) <= '1';with var2 select
				ssegm(6 downto 0)<=
						"0000001" when 0 ,                       --0
						"1001111" when 1,                       --1
						"0010010" when 2 ,                      --2
						"0000110" when 3,                       --3
						"1001100" when 4 ,                      --4
						"0100100" when 5,                       --5
						"0100000" when 6 ,                      --6
						"0001111" when 7,                       --7
						"0000000" when 8 ,                      --8
						"0000100" when 9,                       --9
						"0000001" when others;                        --0
			ssegm(7) <= '1';
end Behavioral;

