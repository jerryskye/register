<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class RegistrationToken extends Model
{
    protected $fillable = [
        'token', 'admin'
    ];
}
