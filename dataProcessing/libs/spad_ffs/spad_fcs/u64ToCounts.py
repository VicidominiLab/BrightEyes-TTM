def u64ToCounts(number):

    """
    Convert an unsigned 64 bit number to a 25 element array containing the
    photon counts for each of the 25 detector elements during a single dwell
    time.

    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    number      Integer number <= 2^64 containing the photon counts for half of
                the detector elements for 1 bin.
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    counts      List of 26 integer numbers with the photon counts for each of
                the 25 detector elements + sum. Zeros are inserted for detector
                elements that are not stored in the number.
    ==========  ===============================================================

    =======
    Example
    =======

    u64ToCounts(13091560953979690842) will return
    [0, 0, 0, 0, 0, 0, 26, 23, 21, 10, 12, 26, 554, 52, 5, 11, 22, 0, 0, 0,...
         0, 0, 0, 0, 0, 759]

    """

    if number < 32:
        counts = [0] * 26
        return counts

    # Convert number to binary list of 64 digits
    number = list('{0:064b}'.format(int(number)))

    # Get time tag
    tt = number[-4:]
    tt = ''.join(tt)
    tt = int(tt, 2)
    del number[-4:]

    # Get cluster type
    clust = number[-1]
    clust = int(clust, 2)
    del number[-1]

    # Create list with 25 0's, one for each detector element
    counts = [0] * 26

    if clust == 0:
        # Data point contains counts of detector elements 0-5, 17-24

        # Detector elements 0-5 (4 bits / element)
        for i in range(6):
            counts[i], number = binaryToCounts(number, 4)

        # Detector element 17 (6 bits long)
        counts[17], number = binaryToCounts(number, 6)

        # Detector element 18 (5 bits long)
        counts[18], number = binaryToCounts(number, 5)

        # Detector elements 19-24 (4 bits / element)
        for i in range(6):
            counts[i+19], number = binaryToCounts(number, 4)

    elif clust == 1:
        # Data point contains counts of detector elements 6-16

        # Detector element 6 (5 bits long)
        counts[6], number = binaryToCounts(number, 5)

        # Detector element 7 (6 bits long)
        counts[7], number = binaryToCounts(number, 6)

        # Detector element 8 (5 bits long)
        counts[8], number = binaryToCounts(number, 5)

        # Detector element 9-10 (4 bits long)
        counts[9], number = binaryToCounts(number, 4)
        counts[10], number = binaryToCounts(number, 4)

        # Detector element 11 (6 bits long)
        counts[11], number = binaryToCounts(number, 6)

        # Detector element 12 (10 bits long)
        counts[12], number = binaryToCounts(number, 10)

        # Detector element 13 (6 bits long)
        counts[13], number = binaryToCounts(number, 6)

        # Detector element 14-15 (4 bits long)
        counts[14], number = binaryToCounts(number, 4)
        counts[15], number = binaryToCounts(number, 4)

        # Detector element 14-15 (5 bits long)
        counts[16], number = binaryToCounts(number, 5)

    counts[25] = sum(counts)

    return counts


def binaryToCounts(number, length):
    """
    Convert the last elements of a binary list to the corresponding photon
    decimal number and remove these elements from the list. Both the number
    and the new list are returned.

    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    number      List of 0's and 1's.
    length      Integer number representing the number of bits that make up the
                last photon count number in the list.
    ==========  ===============================================================

    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    counts      Decimal representation of the binary string of length 'length',
                formed by the last elements in the list.
    number      New binary list with the last 'length' elements removed.
    ==========  ===============================================================

    =======
    Example
    =======

    binaryToCounts(['1', '0', '1', '1'], 3) will return (3, ['1']).
    3: the decimal representation of the last elements in the list (0,1,1)
    ['1']: list with the remaining elements of the original list
    """

    counts = int(''.join(number[-length:]), 2)
    del number[-length:]
    return counts, number
