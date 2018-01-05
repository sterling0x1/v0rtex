#include <errno.h>
#include <string.h>             // strcmp, strerror
#include <sys/utsname.h>        // uname

#include "common.h"             // LOG, kptr_t
#include "offsets.h"

static offsets_t *offsets[] =
{
    // XXX: A few offsets are still in v0rtex.m because they're used in structs,
    //      so moving them here will require rewriting of those parts.
#ifdef __LP64__
    &(offsets_t){
        .version = "Darwin Kernel Version 16.7.0: Thu Jun 15 18:33:36 PDT 2017; root:xnu-3789.70.16~4/RELEASE_ARM64_T7000",
        .base                               = 0xfffffff007004000,
        .sizeof_task                        = 0x550,
        .task_itk_self                      = 0xd8,
        .task_itk_registered                = 0x2e8,
        .task_bsd_info                      = 0x360,
        .proc_ucred                         = 0x100,
        .vm_map_hdr                         = 0x10,
        .ipc_space_is_task                  = 0x28,
        .realhost_special                   = 0x10,
        .iouserclient_ipc                   = 0x9c,
        .vtab_get_retain_count              = 0x3,
        .vtab_get_external_trap_for_index   = 0xb7,
        .zone_map                           = 0xfffffff007558478,
        .kernel_map                         = 0xfffffff0075b4050,
        .kernel_task                        = 0xfffffff0075b4048,
        .realhost                           = 0xfffffff00753aba0,
        .copyin                             = 0xfffffff00718d028,
        .copyout                            = 0xfffffff00718d21c,
        .chgproccnt                         = 0xfffffff00739aa04,
        .kauth_cred_ref                     = 0xfffffff007374d90,
        .ipc_port_alloc_special             = 0xfffffff0070a60b4,
        .ipc_kobject_set                    = 0xfffffff0070b938c,
        .ipc_port_make_send                 = 0xfffffff0070a5bd8,
        .osserializer_serialize             = 0xfffffff00744db90,
        .rop_ldr_x0_x0_0x10                 = 0xfffffff00722a41c,
    },
#else
    &(offsets_t){
        .version = "Darwin Kernel Version 16.7.0: Thu Jun 15 18:33:36 PDT 2017; root:xnu-3789.70.16~4/RELEASE_ARM_S5L8950X",
        .base                               = 0x80001000,
        .sizeof_task                        = 0x3b0,
        .task_itk_self                      = 0x9c,
        .task_itk_registered                = 0x1dc,
        .task_bsd_info                      = 0x22c,
        .proc_ucred                         = 0x98,
        .ipc_space_is_task                  = 0x18,
        .realhost_special                   = 0x8,
        .iouserclient_ipc                   = 0x5c,
        .vtab_get_retain_count              = 0x3,
        .vtab_get_external_trap_for_index   = 0xe1,
        .zone_map                           = 0x804188e0,
        .kernel_map                         = 0x80456034,
        .kernel_task                        = 0x80456030,
        .realhost                           = 0x80404150,
        .copyin                             = 0x80007b9c,
        .copyout                            = 0x80007c74,
        .chgproccnt                         = 0x8027cc17,
        .kauth_cred_ref                     = 0x8025e78b,
        .ipc_port_alloc_special             = 0x80019035,
        .ipc_kobject_set                    = 0x800290b7,
        .ipc_port_make_send                 = 0x80018c55,
        .osserializer_serialize             = 0x8030687d,
        .rop_ldr_r0_r0_0xc                  = 0x802d1d45,
    },
#endif
    NULL,
};

offsets_t* get_offsets(void)
{
    struct utsname u;
    if(uname(&u) != 0)
    {
        LOG("uname: %s", strerror(errno));
        return 0;
    }

    // TODO: load from file

    for(size_t i = 0; offsets[i] != 0; ++i)
    {
        if(strcmp(u.version, offsets[i]->version) == 0)
        {
            return offsets[i];
        }
    }

    LOG("Failed to get offsets for kernel version: %s", u.version);
    return NULL;
}
