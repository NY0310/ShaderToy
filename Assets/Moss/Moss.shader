// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Hidden/Moss"
{
	Properties
	{
		_MainTex ("Main texture", 2D) = "white" {}
        _MossTex ("Moss texture", 2D) = "gray" {}
        _Direction ("Direction", Vector) = (0, 1, 0)
        _Amount ("Amount", Range(0, 1)) = 1
	}
	SubShader
	{
		// No culling or depth
		//Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 nomral : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float2 uvMoss : TEXCOORD1;
				float4 vertex : SV_POSITION;
				float3 nomral : NORMAL;
			};

			sampler2D _MainTex;float4 _MainTex_ST;
			sampler2D _MossTex;float4 _MossTex_ST;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv,_MainTex);
				o.uvMoss = TRANSFORM_TEX(v.uv,_MossTex);
				o.nomral = mul(unity_ObjectToWorld, v.nomral);
				return o;
			}
			
			float3 _Direction;
            fixed _Amount;


			fixed4 frag (v2f i) : SV_Target
			{
				fixed val = dot(normalize(i.normal), _Direction);
                fixed4 mainCol = tex2D(_MainTex, i.uv_Main);
                fixed4 mossCol = tex2D(_MossTex, i.uv_Moss);
                return lerp(mainCol, mossCol, min(_Amount,val,));
			}
			ENDCG
		}
	}
}
