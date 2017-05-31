<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateLecturesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('lectures', function (Blueprint $table) {
            $table->increments('id');
            $table->string('subject');
            $table->integer('user_id')->unsigned()->nullable();
            $table->timestamp('began_at')->nullable();
            $table->timestamp('ended_at')->nullable();
            $table->timestamps();
            $table->foreign('user_id')->references('id')->on('users');
        });

        Schema::table('entries', function (Blueprint $table) {
            $table->integer('lecture_id')->unsigned()->nullable();
            $table->foreign('lecture_id')->references('id')->on('lectures')->onDelete('set null');;
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('entries', function (Blueprint $table) {
          $table->dropForeign('entries_lecture_id_foreign');
        });

        Schema::dropIfExists('lectures');
    }
}
