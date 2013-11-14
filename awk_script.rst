The onliner...
--------------
.. code-block:: bash
    
    awk 'BEGIN{for(i=1;i<=256;i++){ord[sprintf(\"%c\",i)]=i;}}NR%4==0{split(\$0,a,\"\");for(i=1;i<=length(a);i++){if(ord[a[i]]<59){print \"Offset 33\";  exit 0}if(ord[a[i]]>74){print \"Offset 64\";exit 0}}}'


...better explained
-------------------

.. code-block:: bash
    
    awk 'BEGIN { 
            for(i=1;i<=256;i++) {
                ord[sprintf(\"%c\",i)]=i;
            }
        }
        NR%4==0 {
            split(\$0,a,\"\");
            for(i=1;i<=length(a);i++) {
                if(ord[a[i]]<59) {
                    print \"Offset 33\";
                    exit 0
                }
                if(ord[a[i]]>74) {
                    print \"Offset 64\";
                    exit 0
                }
            }
        }'
