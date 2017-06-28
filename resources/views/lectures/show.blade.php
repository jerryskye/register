@extends('layouts.app')

@section('content')
<div class="container">
    <div class="row">
        <div class="col-md-8 col-md-offset-2">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <strong>Subject: {{ $lecture->subject }}</strong><br>
                    <strong>Began at: {{ $lecture->begin }}</strong><br>
                    <strong>Ended at: {{ $lecture->end }}</strong><br>
                </div>
                <div class="panel-body"><h3>Entries:</h3></div>
                <table class="table table-responsive table-hover">
                    <tr>
                        <th>Name</th>
                        <th>Album no.</th>
                        <th>Timestamp</th>
                    </tr>
                @foreach($lecture->entries as $entry)
                    <tr>
                        <td>{{$entry->user->name}}</td>
                        <td>{{$entry->user->album_no}}</td>
                        <td>{{$entry->created_at}}</td>
                    </tr>
                @endforeach
                </table>
            </div>
        </div>
    </div>
</div>
@endsection
