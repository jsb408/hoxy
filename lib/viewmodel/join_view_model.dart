class JoinViewModel {
  String email = '';
  String password = '';
  String phone = '';
  String certNumber = '';
  int birth = 0;

  int get grade => (DateTime.now().year - birth) ~/ 10;
  String get formattedPhone => '+82 ${phone.substring(1)}';

  String checkEmail(String email) {
    this.email = email;

    if(email.isEmpty) return '이메일을 입력해주세요';
    else if(!RegExp('^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*\$').hasMatch(email)) return '올바른 형식이 아닙니다';
    else return null;
  }

  String checkPassword(String password) {
    this.password = password;

    if(password.isEmpty) return '비밀번호를 입력해주세요';
    else if(!RegExp('^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z])(?=.*[!@#\$%^&*()?]).{8,16}\$').hasMatch(password)) return '올바른 형식이 아닙니다';
    else return null;
  }

  String checkConfirm(String confirm) {
    if(confirm.isEmpty) return '비밀번호를 입력해주세요';
    else if(confirm != password) return '입력된 값이 비밀번호와 다릅니다';
    else return null;
  }

  String checkPhone(String phone) {
    this.phone = phone;

    if(phone.isEmpty) return '휴대폰 번호를 입력해주세요';
    else return null;
  }
}