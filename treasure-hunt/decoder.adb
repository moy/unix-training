-- Fichier source pour l'etape quatre et cinq.
-- Ce programme doit etre dans un fichier decoder.adb
-- Compilez-le et executez-le pour continuer.

with Ada.Strings.Fixed, Ada.Strings.Maps, Ada.Text_IO;
use  Ada.Strings.Fixed, Ada.Strings.Maps, Ada.Text_IO;

procedure Decoder is
   function Decode_String (S: String) return String is
   begin
      return Translate(S, To_Mapping("1234567890/abcdefghijklmnopqrstuvwxyz",
                                     "abcdefghijklmnopqrstuvwxyz/1234567890"));
   end;
   Line : String (1..512);
   Last : Natural;
begin
   loop
      Get_Line(Line, Last);
      Put_Line(Decode_String(Line(Line'First..Last)));
   end loop;
exception
   when End_Error => null;
end Decoder;
