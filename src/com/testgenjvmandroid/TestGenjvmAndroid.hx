package com.testgenjvmandroid;

import android.app.Activity;
import android.os.Bundle;

class TestGenjvmAndroid extends Activity
{
	@:overload
	override function onCreate(savedInstanceState:Bundle)
	{
		super.onCreate(savedInstanceState);
		setContentView(R.R_layout.activity_main);
	}
}
