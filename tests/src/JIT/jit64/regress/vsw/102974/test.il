// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

.assembly extern System.Console
{
  .publickeytoken = (B0 3F 5F 7F 11 D5 0A 3A )
  .ver 4:0:0:0
}

// This test was failing due to a bug that existed when we were first bringing up GC on amd64.  Probably won't fail
// anytime soon, but a good case to have.

.assembly extern mscorlib{}
.assembly test{}

.class public auto ansi beforefieldinit Test
       extends [mscorlib]System.Object
{
  .class auto ansi nested public beforefieldinit Dummy
         extends [mscorlib]System.Object
  {
    .field public static bool visited
    .method family hidebysig virtual instance void Finalize() cil managed
    {
      .try
      {
	ldstr      "In Finalize() of Dummy"
	call       void [System.Console]System.Console::WriteLine(string)
	leave.s    IL_0019

      }
      finally
      {
	ldarg.0
	call       instance void [mscorlib]System.Object::Finalize()
	endfinally
      }
      IL_0019:  ret
    }

    .method public hidebysig specialname rtspecialname 
            instance void  .ctor() cil managed
    {
	ldarg.0
	call       instance void [mscorlib]System.Object::.ctor()
	ret
    }

  }

  .field public static int32 count
  .method public hidebysig static void  foo(object o) cil managed
  {
	ldsfld     int32 Test::count
	ldc.i4.s   2
	bne.un.s   IL_0010
	br.s       IL_0041


    IL_0010:  ldsfld     int32 Test::count

	call       void [System.Console]System.Console::WriteLine(int32)
	ldsfld     int32 Test::count
	ldc.i4.1
	add
	stsfld     int32 Test::count
	call       void [mscorlib]System.GC::Collect()
	call       void [mscorlib]System.GC::WaitForPendingFinalizers()
	ldarg.0
	call       void Test::foo(object)
    IL_0041:  ret
  }

  .method public hidebysig static int32  Main() cil managed
  {
    .entrypoint

    .locals init (class Test/Dummy V_0)
	newobj     instance void Test/Dummy::.ctor()
	stloc.0
	ldloc.0
	call       void Test::foo(object)
	ldstr      "After call to foo()"
	call       void [System.Console]System.Console::WriteLine(string)
    	ldc.i4 100
	ret
  }
}
