@extends('layouts.app')

@section('content')
<div class="container">
    <div class="row">
        <div class="col-md-8 col-md-offset-2">
            <div class="panel panel-default">
                <div class="panel-heading">Editing lecture</div>
                <div class="panel-body">
                    <form class="form-horizontal" role="form" method="POST" action="{{ route('lectures.update', ['lecture' => $lecture]) }}">
                        {{ method_field('PUT') }}
                        {{ csrf_field() }}

                        <div class="form-group{{ $errors->has('subject') ? ' has-error' : '' }}">
                            <label for="subject" class="col-md-4 control-label">Subject</label>

                            <div class="col-md-6">
                                <input id="subject" type="text" class="form-control" name="subject" value="{{ old('subject') ?? $lecture->subject }}" required>

                                @if ($errors->has('subject'))
                                    <span class="help-block">
                                        <strong>{{ $errors->first('subject') }}</strong>
                                    </span>
                                @endif
                            </div>
                        </div>

                        <div class="form-group{{ $errors->has('begin') ? ' has-error' : '' }}">
                            <label for="begin" class="col-md-4 control-label">Began at</label>

                            <div class="col-md-6">
                                <input id="begin" type="datetime" class="form-control" name="begin" value="{{ old('begin') ?? $lecture->begin }}" required>

                                @if ($errors->has('begin'))
                                    <span class="help-block">
                                        <strong>{{ $errors->first('begin') }}</strong>
                                    </span>
                                @endif
                            </div>
                        </div>
                        <div class="form-group{{ $errors->has('end') ? ' has-error' : '' }}">
                            <label for="end" class="col-md-4 control-label">Ended at</label>

                            <div class="col-md-6">
                                <input id="end" type="datetime" class="form-control" name="end" value="{{ old('end') ?? $lecture->end }}" required>

                                @if ($errors->has('end'))
                                    <span class="help-block">
                                        <strong>{{ $errors->first('end') }}</strong>
                                    </span>
                                @endif
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-md-6 col-md-offset-4">
                                <button type="submit" class="btn btn-primary">
                                    Submit
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
