<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Entry extends Model
{
    protected $fillable = [
        'uid',
    ];

  public function user() {
    return $this->belongsTo('App\User', 'uid', 'uid');
  }
}
