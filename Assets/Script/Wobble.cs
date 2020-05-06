using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 用于模拟液体晃动效果
/// </summary>
public class Wobble : MonoBehaviour
{
    // Start is called before the first frame update
    public float Recovery = 1f;
    public float WobbleSpeed = 1f;
    public float maxWobble = 0.03f;
    float time = 0.5f;
    float wobbleAmountX;
    float wobbleAmountZ;
    float wobbleAmountToAddX;
    float wobbleAmountToAddZ;
    float pulse = 0;
    Vector3 velocity;
    Vector3 lastPos;
    Vector3 angularVelocity;
    Vector3 lastRot;
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        time += Time.deltaTime;

        /// 获取上一帧计算出来的值 进行计算  传入shader中
        /// 
        wobbleAmountToAddX = Mathf.Lerp(wobbleAmountToAddX, 0, Time.deltaTime * Recovery);
        wobbleAmountToAddZ = Mathf.Lerp(wobbleAmountToAddZ, 0, Time.deltaTime * Recovery);

        pulse = 2 * Mathf.PI * WobbleSpeed;
        wobbleAmountX = wobbleAmountToAddX * Mathf.Sin(pulse * time);
        wobbleAmountZ = wobbleAmountToAddZ * Mathf.Sin(pulse * time);

        ///


        velocity = (lastPos - transform.position) / Time.deltaTime; ///得出当前帧速度 
        angularVelocity = transform.rotation.eulerAngles - lastRot;

        wobbleAmountToAddX += Mathf.Clamp((velocity.x + angularVelocity.z * 0.2f), -maxWobble, maxWobble);
        wobbleAmountToAddZ += Mathf.Clamp((velocity.z + angularVelocity.x * 0.2f), -maxWobble, maxWobble);

        lastPos = transform.position;
        lastRot = transform.rotation.eulerAngles;


    }
}
