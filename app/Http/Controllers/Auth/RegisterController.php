<?php

namespace App\Http\Controllers\Auth;

use App\User;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Foundation\Auth\RegistersUsers;
use Illuminate\Auth\Events\Registered;
use Crypt;
use Illuminate\Contracts\Encryption\DecryptException;
use App\RegistrationToken;

class RegisterController extends Controller
{
    /*
    |--------------------------------------------------------------------------
    | Register Controller
    |--------------------------------------------------------------------------
    |
    | This controller handles the registration of new users as well as their
    | validation and creation. By default this controller uses a trait to
    | provide this functionality without requiring any additional code.
    |
    */

    use RegistersUsers;

    /**
     * Where to redirect users after registration.
     *
     * @var string
     */
    protected $redirectTo = '/home';

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        #$this->middleware('guest');
    }

    /**
     * Get a validator for an incoming registration request.
     *
     * @param  array  $data
     * @return \Illuminate\Contracts\Validation\Validator
     */
    protected function validator(array $data)
    {
        return Validator::make($data, [
            'uid' => 'sometimes|required|string|size:64',
            'album_no' => 'sometimes|required|string|size:6',
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:6|confirmed',
        ]);
    }

    /**
     * Create a new user instance after a valid registration.
     *
     * @param  array  $data
     * @return User
     */
    protected function create(array $data)
    {
        return User::create([
            'uid' => $data['uid'] ?? null,
            'album_no' => $data['album_no'] ?? null,
            'name' => $data['name'],
            'email' => $data['email'],
            'password' => bcrypt($data['password']),
            'admin' => !(array_key_exists('uid', $data) || array_key_exists('album_no', $data)),
        ]);
    }

    protected function handle_registration_token(Request $request) {
      try {
        $ary = json_decode(Crypt::decryptString($request->input('registration')), true);
        if(isset($ary['token'])) {
          $request['uid'] = $ary['uid'];
          return RegistrationToken::where('token', $ary['token'])->delete() > 0;
        }
        else
          return false;
      }
      catch(DecryptException $e) {
        return false;
      }
    }

    public function showRegistrationForm(Request $request)
    {
        if($request->has('registration') and $this->handle_registration_token($request))
          return view('auth.register_'.($request->has('uid') ? 'student' : 'admin'));

        return redirect('/');
    }

    public function register(Request $request)
    {
        $this->validator($request->all())->validate();

        event(new Registered($user = $this->create($request->all())));

        #$this->guard()->login($user);

        return $this->registered($request, $user)
                        ?: redirect($this->redirectPath());
    }
}
