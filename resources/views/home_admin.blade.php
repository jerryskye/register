@extends('layouts.app')

@section('content')
<div class="container">
    <div class="row">
        <div class="col-md-8 col-md-offset-2">
            <div class="panel panel-default">
                <div class="panel-heading"><h2>Your lectures</h2></div>
                <table class="table table-responsive table-hover">
                    <tr>
                        <th>Subject</th>
                        <th>Began at</th>
                        <th>Ended at</th>
                        <th>Attendance</th>
                    </tr>
                @foreach(Auth::user()->lectures as $lecture)
                    <tr>
                        <td>{{$lecture->subject}}</td>
                        <td>{{$lecture->begin}}</td>
                        <td>{{$lecture->end}}</td>
                        <td>{{$lecture->entries()->count()}}</td>
                        <td><a href="{{route('lectures.edit', ['lecture' => $lecture])}}">Edit</a></td>
                        <td><a href="{{route('lectures.show', ['lecture' => $lecture])}}">Show</a></td>
                    </tr>
                @endforeach
                </table>
            </div>
        </div>
    </div>
</div>
@endsection
