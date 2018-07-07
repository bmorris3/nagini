
import numpy as np
# "cimport" is used to import special compile-time information
# about the numpy module (this is stored in a file numpy.pxd which is
# currently part of the Cython distribution).
cimport numpy as np
DTYPE = np.int
# "cty pedef" assigns a corresponding compile-time type to DTYPE_t. For
# every type in the numpy module there's a corresponding compile-time
# type with a _t-suffix.
ctypedef np.float_t DTYPE_t

cimport cython
@cython.boundscheck(False)
@cython.wraparound(False)
def find_overlapping_spots(np.ndarray theta, np.ndarray phi, np.ndarray radius):
    """
    Find overlapping spots in a list of spot objects.

    Parameters
    ----------
    spot_list : list
    tolerance : float
    """
    cdef DTYPE_t tolerance=1.01
    cdef int i, j
    cdef int n = theta.shape[0]
    overlapping_pairs = []
    spots_with_overlap = []
    for i in range(n):
        for j in range(n):
            if i < j:
                sep = np.arccos(np.cos(theta[i]) *
                                np.cos(theta[j]) +
                                np.sin(theta[i]) *
                                np.sin(theta[j]) *
                                np.cos(phi[i] - phi[j]))
                if sep < tolerance * (radius[i] + radius[j]):
                    overlapping_pairs.append((i, j))

                    if i not in spots_with_overlap:
                        spots_with_overlap.append(i)
                    if j not in spots_with_overlap:
                        spots_with_overlap.append(j)

    spots_without_overlap = [i for i in range(n)
                             if i not in spots_with_overlap]
    save_these_spot_indices = [k[0] for k in overlapping_pairs]

    return spots_without_overlap + save_these_spot_indices