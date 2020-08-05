package kro13;
import haxe.macro.Expr.ExprOf;

import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;

class ArrayQuery
{

    public static macro function match<T>(collection:ExprOf<Array<T>>, query:Expr):Expr
    {
        var matchImpl:Expr = null;

        switch (query.expr)
        {
            case EObjectDecl(fields):
                matchImpl = buildAnonQueryExpr(fields);

            default:
                matchImpl = buildQueryExpr(query);
        }

        return macro {
            function()
            {
                var items = [];
                for (item in $collection)
                {
                    if ($matchImpl)
                    {
                        items.push(item);
                    }
                }
                return items;
            }();
        }
    }

    private static function buildAnonQueryExpr(fields:Array<{field:String, expr:haxe.macro.Expr}>):Expr
    {
        #if macro
        //trace(fields);
        var queryFields:Array<String> = [];
        var queryValues:Array<Dynamic> = [];
        for (f in fields)
        {
            //trace(f.expr.expr);
            switch (f.expr.expr)
            {
                case EConst(CInt(v)):
                    queryFields.push(f.field);
                    queryValues.push(v);

                case EConst(CString(v)):
                    queryFields.push(f.field);
                    queryValues.push('\"$v\"');

                case EConst(CFloat(v)):
                    queryFields.push(f.field);
                    queryValues.push(v);

                case EConst(CIdent(v)):
                    queryFields.push(f.field);
                    queryValues.push(v);

                default:
            }
        }

        var checks:Array<String> = [];
        var i:Int = 0;

        //trace(queryFields);

        for (qF in queryFields)
        {
            var checkStr:String = 'item.${qF} == ${queryValues[i]}';
            //trace(checkStr);
            checks.push(checkStr);
            i++;
        }

        var allChecksStr:String = "";
        var i:Int = 0;
        for (check in checks)
        {
            allChecksStr += check;
            if (i < checks.length - 1)
            {
                allChecksStr += " && ";
            }
            i++;
        }

        //trace(allChecksStr);

        return Context.parse(allChecksStr, Context.currentPos());
        #else
        return null;
        #end
    }

    private static function buildQueryExpr(query:Expr):Expr
    {
        #if macro
        var queryFields:Array<String> = getFields(query);
        var queryName:String = getVarName(query);

        var checks:Array<String> = [];

        for (qF in queryFields)
        {
            var checkStr:String = 'item.${qF} == ${queryName}.${qF}';
            //trace(checkStr);
            checks.push(checkStr);
        }

        var allChecksStr:String = "";
        var i:Int = 0;
        for (check in checks)
        {
            allChecksStr += check;
            if (i < checks.length - 1)
            {
                allChecksStr += " && ";
            }
            i++;
        }

        //trace(allChecksStr);

        return Context.parse(allChecksStr, Context.currentPos());
        #else
        return null;
        #end
    }

    private static function getVarName(expr:Expr):String
    {
        #if macro
        var varName:String = "";

        switch (expr.expr)
        {
            case EConst(CIdent(name)):
                varName = name;

            default:
                throw('unsupported expr ${expr.expr}');
        }

        return varName;
        #else
        return null;
        #end
    }

    private static function getFields(expr:Expr):Array<String>
    {
        #if macro
        var t:Type = Context.typeof(expr);
        //trace(expr);
        //trace(t);
        //trace(Context.follow(t));

        var fieldNames:Array<String> = [];

        switch (Context.follow(t))
        {
            case TAnonymous(ref):
                //trace(ref.get().fields);
                var fields:Array<ClassField> = ref.get().fields;
                for (f in fields)
                {
                    //trace('${f.name}');
                    fieldNames.push(f.name);
                }

            case TInst(ref, [TType(type, params)]) if (ref.toString() == "Array"):
                switch(Context.follow(type.get().type))
                {
                    case TAnonymous(ref):
                        //trace(ref.get().fields);
                        var fields:Array<ClassField> = ref.get().fields;
                        for (f in fields)
                        {
                            //trace('${f.name}');
                            fieldNames.push(f.name);
                        }
                    default:
                 }

            case TInst(ref, params):
                trace(ref);
                //trace(ref.get().fields.get());
                var fields:Array<ClassField> = ref.get().fields.get();
                for (f in fields)
                {
                    //trace('${f.name}');
                    fieldNames.push(f.name);
                }

            default:
                throw('unsupported object ${t}');
        }

        return fieldNames;
        #else
        return null;
        #end
    }

}

