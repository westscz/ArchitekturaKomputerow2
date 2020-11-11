/*
 * C-language interface to RDTSC instruction.
 * Read Intel Software Developer Manual vol2 4.2.RDTSC before use!
 * See “Time Stamp Counter” in Chapter 17 of the Intel® 64 and IA-32
 * Architectures Software Developer’s Manual, Volume 3B,
 * for specific details of the time stamp counter behavior.
 *
 * The RDTSC instruction is not a serializing instruction. It does not
 * necessarily wait until all previous instructions have been executed before
 * reading the counter. Similarly, subsequent instructions may begin execution
 * before the read operation is performed. If software requires RDTSC to be
 * executed only after all previous instructions have completed locally, it can
 * either use RDTSCP (if the processor supports that instruction) or execute the
 * sequence LFENCE;RDTSC.
 *
 * The RDTSCP instruction waits until all previous instructions have been
 * executed before reading the counter.  However, subsequent instructions may
 * begin execution before the read operation is performed.
 *
 */
unsigned long long int rdtsc(void)
{
    unsigned long long int x;
    unsigned a, d;

    __asm__ volatile("rdtsc" : "=a" (a), "=d" (d));

    return ((unsigned long long)a) | (((unsigned long long)d) << 32);;
}

