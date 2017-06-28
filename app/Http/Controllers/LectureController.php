<?php

namespace App\Http\Controllers;

use App\Lecture;
use Illuminate\Http\Request;
use Auth;
use Illuminate\Support\Facades\Validator;
use Carbon\Carbon;

class LectureController extends Controller
{
    public function __construct() {
        $this->middleware('auth');
    }

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Lecture  $lecture
     * @return \Illuminate\Http\Response
     */
    public function show(Lecture $lecture)
    {
        return Auth::id() == $lecture->user_id ? view('lectures/show', ['lecture' => $lecture]) : response()->view('unauthorized', [], 403);
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Lecture  $lecture
     * @return \Illuminate\Http\Response
     */
    public function edit(Lecture $lecture)
    {
        return Auth::id() == $lecture->user_id ? view('lectures/edit', ['lecture' => $lecture]) : response()->view('unauthorized', [], 403);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Lecture  $lecture
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Lecture $lecture)
    {
        if(Auth::id() != $lecture->user_id)
            return response('You are unauthorized to access this resource.', 403);

        $this->validator($request->all())->validate();

        $lecture->subject = $request['subject'];
        $lecture->begin = Carbon::parse($request['begin']);
        $lecture->end = Carbon::parse($request['end']);
        $lecture->save();

        return view('lectures/update');
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Lecture  $lecture
     * @return \Illuminate\Http\Response
     */
    public function destroy(Lecture $lecture)
    {
        //
    }

    protected function validator(array $data)
    {
        return Validator::make($data, [
            'subject' => 'required|string|max:255',
            'begin' => 'required|date',
            'end' => 'required|date',
        ]);
    }
}
