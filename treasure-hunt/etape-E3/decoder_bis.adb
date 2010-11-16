-- Fichier source pour l'etape cinq.
-- Ce programme doit etre dans un fichier decoder_bis.adb
-- Compilez-le et executez-le pour continuer.

with Ada.Strings.Fixed, Ada.Strings.Maps, Ada.Text_IO;
use  Ada.Strings.Fixed, Ada.Strings.Maps, Ada.Text_IO;

procedure Decoder_Bis is
   function Decode_String (S: String) return String is
   begin
      return Translate(S, To_Mapping("1234567890xyztabcdef", "abcdef1234567890xyzt"));
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
end Decoder_Bis;
