-- Listing 4.16
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity hex_mux_test is
   generic (
            N :  std_logic_vector:=x"5F5E0FF"; -- count from 0 to M-1
            M : integer := 26   -- M bits required to count upto N i.e. 2**M >= N
    );
    Port ( clk : in  STD_LOGIC;
           an : out  STD_LOGIC_vector(3 downto 0);
           sseg : out  STD_LOGIC_vector(7 downto 0);
           rst : in  STD_LOGIC);
end hex_mux_test;

architecture arch of hex_mux_test is
   signal bcd: std_logic_vector(13 downto 0);
	signal one_sec_counter: std_logic_vector(M downto 0);
	signal one_sec_en: std_logic;
	signal a,b,c,d: std_logic_vector(3 downto 0);
begin
 
	 disp_unit: entity work.disp_hex_mux
			port map(
				clk=>clk, reset=>'0',
				hex3=>d, hex2=>c,
				hex1=>b, hex0=>a,
				dp_in=>"1111", an=>an, sseg=>sseg);

		-- One second Pulse or tick
		process(clk,rst)
		begin
				if rst='1' then 
						one_sec_counter <= (others=>'0');
				elsif rising_edge(clk) then
						if one_sec_counter=N then
								one_sec_counter <= (others=>'0');
						else 
								one_sec_counter <= one_sec_counter +"1";
						end if;
				end if;
		end process;
		one_sec_en <= '1' when one_sec_counter=N else '0';
		
		--- BCD counter
		process(clk_in,rst)
		begin
				if rst='1' then
						bcd<=(others=>'0');
				elsif rising_edge(clk_in) then
						if one_sec_en='1' then 
							if  bcd(15 downto 0)="1001100110011001" then
							bcd(15 downto 0)<=(others=>'0');
							elsif bcd(11 downto 0)="100110011001" then
									bcd(11 downto 0)<=(others=>'0');
							elsif bcd(7 downto 0)="10011001" then
									bcd(7 downto 8)<=(others=>'0');
							elsif bcd(3 downto 0)="1001" then
									bcd(3 downto 0)<=(others=>'0');
								else
								   bcd(3 downto 0)<=bcd(3 downto 0) +"1";
							end if;
									
										
								
				end if;
		end process;
		
		a<=bcd(3 downto 0);
		b<=bcd(7 downto 4);
		c<=bcd(11 downto 8);
		d<=bcd(15 downto 12);
 
 
end arch;

