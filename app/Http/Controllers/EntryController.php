<?php

namespace App\Http\Controllers;

use Validator;
use App\Entry;
use Illuminate\Http\Request;
use Crypt;
use Illuminate\Contracts\Encryption\DecryptException;

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
        Entry::create($data);
        return response()->json(['errors' => []], 201);
      }
    }
}
