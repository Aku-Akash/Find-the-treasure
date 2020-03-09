----------------------------------------------------------------------------------
-- Company: COL215
-- Engineer: AKASH S
-- 
-- Create Date: 10.11.2019 18:47:40
-- Design Name: 
-- Module Name: mouse - Behavioral
-- Project Name: Find the treasure
-- Target Devices: FPGA 
-- Tool Versions:
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
use IEEE.NUMERIC_STD.ALL;

entity mouse is
  Port (
    start1 : in std_logic;      -- start button
    restart: in std_logic;      -- restart button
    clk: in std_logic;          -- 100MHz clock
    mouse_ps2: in std_logic;    -- data sent by mouse
    mouse_clk: in std_logic;    -- clock sent by mouse
    cath: out std_logic_vector(6 downto 0); -- cathode of seven segment display
    anod: out std_logic_vector(3 downto 0); -- anode of seven segment display
    leds: out std_logic_vector(15 downto 0) -- LEDs in FPGA board
     );
end mouse;

architecture Behavioral of mouse is
    type state_type is (idle,active,idol,score_gen); -- idle - initial state, active - ... , idol - .., score_gen - score displayed
    type sta is (st,nxt); 
    signal scoree :integer := 0;
    signal state_time : sta;
    signal m_bits : integer := 0;
    signal one_sec: integer:= 0; -- counter to generate one second clk enable
    signal score: integer:=0;
    signal refresh: std_logic_vector(20 downto 0);
    signal counter : integer:=0;
    signal flag: std_logic := '0';
    signal x_coord : std_logic_vector(7 downto 0) := "00000000";
    signal cc : integer := 0;
    signal a_sec : std_logic := '0';
    signal x_s: std_logic;
    signal x_cood: integer := 10;
    signal y_cood: integer := 10;
    signal rand_x: integer := -80;
    signal rand_y: integer := 80;
    signal state: state_type := idle;
    signal no_of_ones: integer := 0;
    signal sig : std_logic_vector(1 downto 0);
    signal no : integer := 0;
    signal no_one: integer:=0;
    signal clk_1hz: std_logic := '0';
    signal time: integer := 0;
    signal x_cd : std_logic_vector(7 downto 0) := "00000000";
    signal lpress: integer:=0;
    signal y_cd : std_logic_vector(7 downto 0) := "00000000";
    signal xvel : integer := 0;
    signal yvel : integer := 0;
    signal led : std_logic_vector(15 downto 0) := "0000000000000000";
    signal xco: integer;
    signal yco : integer;
   
begin
     process(mouse_clk)
     begin
     if(mouse_clk ='1' and mouse_clk'event) then
       if(state = active) then
         if(m_bits <= 31) then
           m_bits <= m_bits +1;
         else
           m_bits <= 0;                
         end if;
       end if;
       if(state = idle) then
         m_bits <= 0;  
       end if;
     end if;
  
     if(mouse_clk = '0' and mouse_clk'event) then
       if(state = idle) then
         if(mouse_ps2 = '0') then
           state <= active;
         end if;
       end if;
       if(state = active) then
         if(mouse_ps2 = '1') then
           no_of_ones <= no_of_ones + 1;
         end if;
         if(m_bits = 3) then
           if(mouse_ps2 = '1') then
             state <= idle;
           end if;
         end if;
         if(m_bits = 4) then
           if(mouse_ps2 = '0') then
             state<= idle;
           end if;
         end if;
         if(m_bits = 5) then
           x_s <= mouse_ps2;
         end if;
         if(m_bits=6) then
           if(x_s = '0' and mouse_ps2 = '0') then
             sig <= "00";
           end if;
           if(x_s = '0' and mouse_ps2 = '1') then
             sig <= "01";
           end if;
           if(x_s = '1' and mouse_ps2 = '0') then
             sig <= "10";
           end if;
           if(x_s ='1' and mouse_ps2 = '1') then
             sig <= "11";                        
           end if;
         end if;
         if(m_bits = 9) then
           if(no_of_ones mod 2 = 0) then
             if(mouse_ps2 = '0') then
               state<= idle;           
             end if;
           else
             if(mouse_ps2 = '1') then
               state <= idle;
               no_of_ones <= 0;
               no_one <= 0;
               no <= 0;
             end if;
           end if;       
         end if;
         if(m_bits = 10) then
           if(mouse_ps2 = '0') then
             state <= idle;
             no_of_ones <= 0;
             no_one <= 0;
             no <= 0;
           end if;
         end if;
         if(m_bits = 11) then
           if(mouse_ps2 = '1') then
             state<= idle;
             no_of_ones <= 0;
             no_one <= 0;
             no <= 0;
           end if;
         end if;
         if(m_bits = 12) then
           x_cd <= x_cd(6 downto 0) & mouse_ps2;
           if(mouse_ps2 = '1') then
             no_one <= no_one+1;
           end if;
         end if;             
         if(m_bits = 13) then
           x_cd <= x_cd(6 downto 0) & mouse_ps2;
           if(mouse_ps2 = '1') then
             no_one <= no_one+1;
           end if;
         end if;         
         if(m_bits = 14) then
           x_cd <= x_cd(6 downto 0) & mouse_ps2;
           if(mouse_ps2 = '1') then
             no_one <= no_one+1;
           end if;
         end if;    
         if(m_bits = 15) then
           x_cd <= x_cd(6 downto 0) & mouse_ps2;  
           if(mouse_ps2 = '1') then
             no_one <= no_one+1;
           end if; 
         end if;
         if(m_bits = 16) then
           x_cd <= x_cd(6 downto 0) & mouse_ps2;  
           if(mouse_ps2 = '1') then
             no_one <= no_one+1;
           end if;  
         end if;             
         if(m_bits = 17) then
           x_cd <= x_cd(6 downto 0) & mouse_ps2;
           if(mouse_ps2 = '1') then
             no_one <= no_one+1;
           end if;
         end if;              
         if(m_bits = 18) then
           x_cd <= x_cd(6 downto 0) & mouse_ps2;
           if(mouse_ps2 = '1') then
             no_one <= no_one+1;
           end if;
         end if;              
         if(m_bits = 19) then
           x_cd <= x_cd(6 downto 0) & mouse_ps2;
           if(mouse_ps2 = '1') then
             no_one <= no_one+1;
           end if;
         end if;            
         if(m_bits = 20) then
           if(no_one mod 2 = 0) then
             if(mouse_ps2 = '0') then
               state <= idle;
               no_of_ones <= 0;
               no_one <= 0;
               no <= 0;
             end if;
           end if;
           if(no_one mod 2 = 1) then
             if(mouse_ps2 = '1') then
               state <= idle;
               no_of_ones <= 0;
               no_one <= 0;
               no <= 0;
             end if;
           end if;
         end if;
         if(m_bits = 21) then
           if(mouse_ps2 = '0') then
             state <= idle;
             no_of_ones <= 0;
             no_one <= 0;
             no <= 0;
           end if;
         end if;           
         if(m_bits = 22) then
           if(mouse_ps2 = '1') then
             state <= idle;
             no_of_ones <= 0;
             no_one <= 0;
             no <= 0;
           end if;
         end if;          
         if(m_bits = 23) then
           y_cd <= y_cd(6 downto 0) & mouse_ps2;
           if(mouse_ps2 = '1') then
             no <= no+1;
           end if;
         end if;                                   
         if(m_bits = 24) then
           y_cd <= y_cd(6 downto 0) & mouse_ps2;
           if(mouse_ps2 = '1') then
             no <= no+1;
           end if;
         end if;                         
         if(m_bits = 25) then
           y_cd <= y_cd(6 downto 0) & mouse_ps2;
           if(mouse_ps2 = '1') then
             no <= no+1;
           end if;
         end if;                            
         if(m_bits = 26) then
           y_cd <= y_cd(6 downto 0) & mouse_ps2;  
           if(mouse_ps2 = '1') then
             no <= no+1;
           end if; 
         end if;
         if(m_bits = 27) then
           y_cd <= y_cd(6 downto 0) & mouse_ps2;  
           if(mouse_ps2 = '1') then
             no <= no+1;
           end if;  
         end if;                               
         if(m_bits = 28) then
           y_cd <= y_cd(6 downto 0) & mouse_ps2;
           if(mouse_ps2 = '1') then
             no <= no+1;
           end if;
         end if;                        
         if(m_bits = 29) then
           y_cd <= y_cd(6 downto 0) & mouse_ps2;
           if(mouse_ps2 = '1') then
             no <= no+1;
           end if;
         end if;                             
         if(m_bits = 30) then
           y_cd <= y_cd(6 downto 0) & mouse_ps2;
           if(mouse_ps2 = '1') then
             no <= no+1;
           end if;
         end if;                               
         if(m_bits = 31) then
           if(no mod 2 = 0) then
             if(mouse_ps2 = '0') then
               state <= idle;
               no_of_ones <= 0;
               no_one <= 0;
               no <= 0;
               end if;
           end if;
           if(no mod 2 = 1) then
             if(mouse_ps2 = '1') then
               state <= idle;
               no_of_ones <= 0;
               no_one <= 0;
               no <= 0;
             end if;
           end if;
         end if;                                  
         if(m_bits = 32) then
           state <= idol;                        
           no_of_ones <= 0; 
           no_one <= 0;
           no <= 0;
           xvel <= to_integer(unsigned(x_cd));
           yvel <= to_integer(unsigned(y_cd));                 
         end if;  
       end if;
       if(state = idol) then
         if(sig = "00") then
           if(not (xvel = 0)) then
             x_cood <= x_cood +1;
             if(x_cood = 20) then
               xco <= xco + 2;
               x_cood <= 0;
             end if;
           end if;
           if(not(yvel=0)) then
             y_cood <= y_cood + 1;
             if(y_cood = 20) then
               yco <= yco +2;
               y_cood <= 0;
             end if;
           end if;
         end if;
         if(sig = "01") then
           if(not (xvel = 0)) then
             x_cood <= x_cood +1;
             if(x_cood = 20) then
               xco <= xco + 2;
               x_cood <= 0;
             end if;
           end if;
           if(not(yvel=0)) then
             y_cood <= y_cood - 1;
             if(y_cood = -20) then
               yco <= yco -2;
               y_cood <= 0;
             end if;
           end if;
         end if;
         if(sig = "10") then
           if(not (xvel = 0)) then
             x_cood <= x_cood -1;
             if(x_cood = -20) then
               xco <= xco -2;
               x_cood <= 0;
             end if;
           end if;
           if(not(yvel=0)) then
             y_cood <= y_cood + 1;
             if(y_cood = 20) then
               yco <= yco + 2;
               y_cood <= 0;
             end if;
           end if;     
         end if;
         if(sig = "11") then
           if(not (xvel = 0)) then
             x_cood <= x_cood -1;
             if(x_cood = -20) then
               xco <= xco -2;
               x_cood <= 0;
             end if;
           end if;
           if(not(yvel=0)) then
             y_cood <= y_cood - 1;
             if(y_cood = -20) then
               yco <= yco -2;
               y_cood <= 0;
             end if;
           end if;
         end if;
         if(xco = 100 or xco=-100) then
           xco <= 0;
           yco <= 0;
         end if;
         if(yco = 100 or yco = -100) then
           yco <= 0;
           xco <= 0;
         end if;
         state <= score_gen;
       end if;
       if(state = score_gen) then
         score <= 100 - ((rand_x - xco)*(rand_x-xco) + (rand_y - yco)*(rand_y-yco))/800;     
         state <= idle;
       end if;
     end if;
     end process;

     process(clk) -- 1Hz clock to count seconds
     begin
       if(clk='1' and clk'event) then
         if(counter <= 100000000) then
           counter <= counter +1;
           clk_1hz <= '0';
         else
           counter <= 0;
           clk_1hz <= '1';
         end if;
       end if;
     end process; 
    
     process(clk_1hz,start1,restart) -- process to hande the timer
       begin
         if(restart='1') then  -- restart brings the state to intial state and sets the time to 0
           time <= 0;
           state_time <= st;
         end if;
         case state_time is                    
           when st => -- idle state 
           if(start1 = '1') then -- if start button is pressed
             state_time <= nxt; 
           end if;
           when nxt => -- counting state
           if(clk_1hz ='1' and clk_1hz'event) then
             if(time = 99) then -- if the time is over
               state_time <= st; -- set state back to intial state
             elsif(score = 99) then
               state_time <= st;
             leds(15 downto 0) <= "1111111111111111";
             else
               time <= time+1;
             end if;
           end if;
           when others =>
             null;
         end case;        
     end process;
              
     sevenpro: ENTITY WORK.seven(Behavioral)
       PORT MAP(clk,restart,anod,cath,score,time);

end Behavioral;
