import 'package:base_codecs/base_codecs.dart';
import 'package:otp/otp.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:convert';

class OtpGeneratorService {


  encode32String(String code) {
    final base32Rfc = Base32CodecRfc();
    final bytes = utf8.encode(code);
    final encodedString = base32Rfc.encode(bytes);
    return encodedString;
  }

  generateOtp() {
    tz.initializeTimeZones();
    tz.initializeTimeZones();
    final london = tz.getLocation('Europe/London');
    final now = tz.TZDateTime.now(london);

    //Generate a TOTP code
    final secret = encode32String('JBSWY3DPEHPK3PXP');

    final totpCode = OTP.generateTOTPCodeString(
      secret,
      now.millisecondsSinceEpoch,
      algorithm: Algorithm.SHA1,
      isGoogle: true,
    );
    return totpCode;
  }

  
}