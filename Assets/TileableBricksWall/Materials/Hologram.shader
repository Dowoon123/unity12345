Shader "Custom/Hologram" {
	Properties{
		_BumpMap("Normal Map",2D) = "bump"{}
	_Color("Color",Color) = (1,1,1,1)
		_HologramPower("HologramPower",Range(0.5,5)) = 3
		_HologramBlinkSpeed("HologramBlinkSpeed",Range(0,50)) = 1
		_HologramBlinkRange("HologramBlinkRange",Range(0.5,1.0)) = 0.5
		_LineSpeed("LineSpeed",Range(1,30)) = 1
		_LinePower("LinePower",Range(0,1)) = 1
		_LineCount("LineCount",Range(0,100)) = 3
		_LineSize("LineSize",Range(0,100)) = 30
	}
		SubShader{
		Tags{ "RenderType" = "Transparent" "Queue" = "Transparent" }

		CGPROGRAM
#pragma surface surf nolight noambient alpha:fade
		//빛의 영향을 받을 필요가 없어 nolight라는 커스텀 라이트 생성

		sampler2D _BumpMap;
	fixed4 _Color;
	fixed _HologramPower;
	fixed _HologramBlinkSpeed;
	fixed _HologramBlinkRange;
	fixed _LineSpeed;
	fixed _LinePower;
	fixed _LineCount;
	fixed _LineSize;

	struct Input {
		float2 uv_BumpMap;
		float3 viewDir;
		//보는 방향의 벡터
		float3 worldPos;
		//월드 공간상의 위치
	};

	void surf(Input IN, inout SurfaceOutput o) {
		o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
		//노멀맵 적용

		fixed rim = saturate(dot(o.Normal, IN.viewDir));
		//노멀과 뷰벡터 닷연산
		rim = pow(1 - rim, _HologramPower);
		//반전시킨 림을 제곱
		fixed fline = pow(frac(IN.worldPos.g * _LineCount - (_Time.y * _LineSpeed)), _LineSize) * _LinePower;
		//반복되는 worldPos의 y값을 위로 올리며 줄을 계산
		o.Emission = _Color.rgb;
		//설정한 컬러를 가짐
		o.Alpha = (rim + fline) * (sin(_Time.y * _HologramBlinkSpeed) * 0.5 + _HologramBlinkRange);
		//sin(Time)(rim+fline)
	}

	float4 Lightingnolight(SurfaceOutput s, float3 lightDir, float atten) {
		return float4(0, 0, 0, s.Alpha);
		//알파 채널만 반환
	}
	ENDCG
	}
		FallBack "Transparent/Diffuse"
		//그림자를 생성하지 않음
}


