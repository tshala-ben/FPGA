----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:04:37 03/18/2021 
-- Design Name: 
-- Module Name:    bcd_compteur - Behavioral 
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bcd_compteur is
generic (
            N :  std_logic_vector:=x"5F5E0FF" );  -- count from 0 to M-1
end bcd_compteur;

architecture Behavioral of bcd_compteur is

	  signal one_sec_counter: std_logic_vector(M downto 0);
	  signal one_sec_en: std_logic;
	  signal bcd: std_logic_vector(15 downto 0);
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
		one_sec_en <= '1' when one_sec_counter= N else '0';
	   
		-- BCD counter
		process(clk_in,rst)
		begin
				if rst='1' then
						bcd<=(others=>'0');
				elsif rising_edge(clk_in) then
						if one_sec_en='1' then 
						if  bcd(15 downto 12)="1001" and bcd(11 downto 8)="1001"and bcd(7 downto 4)="1001" and bcd(3 downto 0)="1001" then
							bcd(15 downto 12)<=(others=>'0');
								else
										bcd(15 downto 12)<=bcd(15 downto 12) +"1";
										end if;
								if bcd(11 downto 8)="1001"and bcd(7 downto 4)="1001" and bcd(3 downto 0)="1001" then
									bcd(11 downto 8)<=(others=>'0');
									else
									bcd(11 downto 8)<=bcd(11 downto 8) +"1";
									end if;
									
										
								if bcd(7 downto 4)="1001" and bcd(3 downto 0)="1001" then
										bcd(7 downto 4)<=(others=>'0');
									
								else
										bcd(7 downto 4)<=bcd(7 downto 4) +"1";
								end if;
							
								
								if bcd(3 downto 0)="1001"  then
								bcd(3 downto 0)<=(others=>'0');	
								else
										bcd(3 downto 0)<=bcd(3 downto 0) +"1";
								end if;
						end if;
				end if;
		end process;

end Behavioral;


