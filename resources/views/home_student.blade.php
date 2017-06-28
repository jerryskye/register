@extends('layouts.app')

@section('content')
<div class="container">
    <div class="row">
        <div class="col-md-8 col-md-offset-2">
            <div class="panel panel-default">
                <div class="panel-heading"><h2>Your entries</h2></div>
                <table class="table table-responsive table-hover">
                    <tr>
                        <th>Subject</th>
                        <th>Lecturer</th>
                        <th>Timestamp</th>
                    </tr>
                @foreach(Auth::user()->entries as $entry)
                    <tr>
                        @if($entry->lecture === null)
                        <td>N/A</td>
                        <td>N/A</td>
                        @else
                        <td>{{$entry->lecture->subject}}</td>
                        <td>{{$entry->lecture->user->name}}</td>
                        @endif
                        <td>{{$entry->created_at}}</td>
                    
                    </tr>
                @endforeach
                </table>
            </div>
        </div>
    </div>
</div>
@endsection
