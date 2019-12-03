Shader "Hidden/Distorting"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Intensity ("Intensity", Range(0, 50)) = 0
	}
	
	SubShader
	{
		// No culling or depth
		Tags { "Queue"="Transparent" }
		GrabPass { "_GrabTexture" }
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
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 grabPos : TEXCOORD1;
			};

			sampler2D _GrabTexture;
            half _Intensity;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				o.grabPos = ComputeGrabScreenPos(o.vertex);
				return o;
			}
			
			sampler2D _MainTex;

			fixed4 frag (v2f i) : SV_Target
			{
				 i.grabPos.x += sin((_Time.y + i.grabPos.y) * _Intensity)/20;
				fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.grabPos));
				return col;
			}
			ENDCG
		}
	}
}
