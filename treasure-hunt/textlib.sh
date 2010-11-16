. uuidlib.sh

make_noise () {
    for i in $(seq $(($RANDOM % 4 + 1))); do
        head -n $(($RANDOM % 10)) chap1
        date
        uuid
    done
}

fake_answer () {
    case $(($RANDOM % 4)) in
	0)
	    echo "La réponse est XYZ${hashes[$((i % 100 + 1))]} ."
	    ;;
	1)
	    echo "La réponse est ${hashes[$((i % 100 + 1))]}XYZ ."
	    ;;
	2)
	    echo "XYZ La réponse est ${hashes[$((i % 100 + 1))]} ."
	    ;;
	3)
	    echo "La réponse XYZ est ${hashes[$((i % 100 + 1))]} ."
	    ;;
    esac
}
