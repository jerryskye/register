<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Lecture extends Model
{
    protected $fillable = [
        'subject', 'user_id', 'begin', 'end',
    ];

    public function user() {
      return $this->belongsTo('App\User');
    }

    public function entries() {
      return $this->hasMany('App\Entry');
    }
}
