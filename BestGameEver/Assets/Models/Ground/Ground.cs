using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Ground : MonoBehaviour
{
    private void Start()
    {
        int randomizer = Random.Range(1,4);
        gameObject.transform.rotation =  Quaternion.Euler(0,  90 * randomizer, 0);
    }

}
