<?php

namespace App\Http\Controllers;

use Validator;
use App\Entry;
use Illuminate\Http\Request;
use Crypt;
use Illuminate\Contracts\Encryption\DecryptException;
use App\User;
use Carbon\Carbon;
use App\Lecture;

class EntryController extends Controller
{
    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
      try {
        $data = json_decode(Crypt::decryptString($request->getContent()), true) ?? [];
      }
      catch(DecryptException $e) {
        return response()->json(['errors' => ["You didn't say the magic word!"]], 403);
      }

      $validator = Validator::make($data, [
        'uid' => 'required|string|size:64'
      ]);

      if($validator->fails())
        return response()->json(['errors' => $validator->errors()], 422);
      else {
        if($user = User::where(['uid' => $data['uid'], 'admin' => true])->first())
          Lecture::create(['subject' => null, 'user_id' => $user->id, 'begin' => Carbon::now(), 'end' => Carbon::now()->addMinutes(90)]);
        else {
          $lecture = Lecture::where([['begin', '<=', Carbon::now()], ['end', '>=', Carbon::now()]])->first();
          if($lecture != null)
            $data['lecture_id'] = $lecture->id;
          Entry::create($data);
        }
        return response()->json(['errors' => []], 201);
      }
    }
}
