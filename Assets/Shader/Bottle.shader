Shader "Unlit/Bottle"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Fill("_FillAmount",float) = 1
        _WobbleX("Wobblex",Range(-1,1))=0.0
        _WobbleZ("WobbleZ",Range(-1,1))=0.0
    }
    SubShader
    {
        Tags { "Queue"="Geometry" "DisableBatching"="True"  }
        LOD 100

        Pass
        {
            Cull Back
            ZWrite On
        //    AlphaToMask on //用于剔除黑色部分
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float height :TEXCOORD1;
                float4 pos :TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Fill;
            float _float;
            float _WobbleX;
            float _WobbleZ;

		   float getSine(float x){
				return sin(2*3.14159*(x))*0.03;
			}    

            ///输入世界坐标 输出的旋转坐标
            // 原来的 x-> 原来的y
            // 原来的 y -> 原来的z
            // 原来的 z -> 旋转后的x 

            //最后输出的 x-> 原来的y 
            // y-> 原来的z 
            // z->旋转后的x 
			float4 RotateAroundYInDegrees (float4 vertex, float degrees)
			 {
				float alpha = degrees * UNITY_PI / 180;
				float sina, cosa;
				sincos(alpha, sina, cosa);
				float2x2 m = float2x2(cosa, sina, -sina, cosa);
				return float4(vertex.yz , mul(m, vertex.xz)).xzyw ;				
			 } 

            v2f vert (appdata v)
            {
                v2f o;


                o.uv=TRANSFORM_TEX(v.uv,_MainTex);
                o.vertex =  UnityObjectToClipPos( v.vertex);

                float3 worldPos = mul(unity_ObjectToWorld,v.vertex.xyz); //此处如果用xyzw 把w分量页进行转换会导致以世界坐标0点为root坐标
                float3 worldPosX = RotateAroundYInDegrees(float4(worldPos,0),360);
                float3 worldPosZ = float3(worldPosX.y,worldPosX.z,worldPosX.x);
                float3 worldPosAdjusted =worldPos+ (worldPosX*_WobbleX )+ (worldPosZ*_WobbleZ );

                o.height  = _Fill + worldPosAdjusted.y;

                o.pos = float4( worldPosAdjusted,0);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				float4  col =tex2D(_MainTex,i.uv) ;
                
                return i.height; 
            }
            ENDCG
        }
    }
}
