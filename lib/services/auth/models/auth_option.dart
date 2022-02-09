class AuthMethod {

  final String name;

  AuthMethod._(this.name);

  factory AuthMethod.withToken(String token) => WithToken._(token);

  factory AuthMethod.emailAndPassword(String email, String password) => EmailAndPassword._(email, password);

  factory AuthMethod.withGoogle() => WithGoogle._();

  factory AuthMethod.withFacebook() => WithFacebook._();

  factory AuthMethod.withApple() => WithApple._();
}

class Anonymous extends AuthMethod {
  Anonymous(): super._("anonymous");
}

class EmailAndPassword extends AuthMethod {
   final String email;
   final String password;

  EmailAndPassword._(this.email, this.password): super._("email_and_password");
}

class WithToken extends AuthMethod {
  final String token;
  WithToken._(this.token): super._("with_token");
}

class WithGoogle extends AuthMethod {
  WithGoogle._(): super._("with_google");
}

class WithApple extends AuthMethod {
  WithApple._(): super._("with_apple");
}

class WithFacebook extends AuthMethod {
  WithFacebook._(): super._("with_facebook");
}